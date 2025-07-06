#!/bin/bash

# E-commerce API Deployment Script
# This script automates the deployment process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${1:-staging}
IMAGE_TAG=${2:-latest}
NAMESPACE="ecommerce-${ENVIRONMENT}"

echo -e "${BLUE}🚀 Starting deployment for ${ENVIRONMENT} environment${NC}"

# Check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}📋 Checking prerequisites...${NC}"
    
    command -v kubectl >/dev/null 2>&1 || { echo -e "${RED}❌ kubectl is required but not installed${NC}"; exit 1; }
    command -v docker >/dev/null 2>&1 || { echo -e "${RED}❌ docker is required but not installed${NC}"; exit 1; }
    command -v helm >/dev/null 2>&1 || { echo -e "${RED}❌ helm is required but not installed${NC}"; exit 1; }
    
    echo -e "${GREEN}✅ Prerequisites check passed${NC}"
}

# Build and push Docker image
build_and_push() {
    echo -e "${YELLOW}🔨 Building Docker image...${NC}"
    
    # Build the image
    docker build -t ecommerce-api:${IMAGE_TAG} .
    
    # Tag for registry
    docker tag ecommerce-api:${IMAGE_TAG} ${ECR_REPOSITORY}:${IMAGE_TAG}
    
    # Push to registry
    echo -e "${YELLOW}📤 Pushing image to registry...${NC}"
    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
    docker push ${ECR_REPOSITORY}:${IMAGE_TAG}
    
    echo -e "${GREEN}✅ Image built and pushed successfully${NC}"
}

# Deploy to Kubernetes
deploy_to_k8s() {
    echo -e "${YELLOW}🚢 Deploying to Kubernetes...${NC}"
    
    # Create namespace if it doesn't exist
    kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
    
    # Update image tag in deployment
    sed -i "s|{{IMAGE_TAG}}|${IMAGE_TAG}|g" k8s/${ENVIRONMENT}/deployment.yaml
    
    # Apply configurations
    kubectl apply -f k8s/${ENVIRONMENT}/
    
    # Wait for rollout to complete
    kubectl rollout status deployment/ecommerce-api -n ${NAMESPACE} --timeout=600s
    
    echo -e "${GREEN}✅ Deployment completed successfully${NC}"
}

# Health check
health_check() {
    echo -e "${YELLOW}🏥 Performing health check...${NC}"
    
    # Get service endpoint
    if [ "${ENVIRONMENT}" = "production" ]; then
        ENDPOINT="https://api.ecommerce.com"
    else
        ENDPOINT="http://${ENVIRONMENT}.ecommerce-api.local"
    fi
    
    # Wait for service to be ready
    for i in {1..30}; do
        if curl -f ${ENDPOINT}/actuator/health > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Health check passed${NC}"
            return 0
        fi
        echo -e "${YELLOW}⏳ Waiting for service to be ready... (${i}/30)${NC}"
        sleep 10
    done
    
    echo -e "${RED}❌ Health check failed${NC}"
    exit 1
}

# Rollback function
rollback() {
    echo -e "${RED}🔄 Rolling back deployment...${NC}"
    kubectl rollout undo deployment/ecommerce-api -n ${NAMESPACE}
    kubectl rollout status deployment/ecommerce-api -n ${NAMESPACE}
    echo -e "${GREEN}✅ Rollback completed${NC}"
}

# Cleanup function
cleanup() {
    echo -e "${YELLOW}🧹 Cleaning up...${NC}"
    # Remove local Docker images
    docker rmi ecommerce-api:${IMAGE_TAG} 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

# Main execution
main() {
    trap cleanup EXIT
    trap rollback ERR
    
    check_prerequisites
    
    if [ "${BUILD_IMAGE}" = "true" ]; then
        build_and_push
    fi
    
    deploy_to_k8s
    health_check
    
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${BLUE}📊 Service Info:${NC}"
    kubectl get pods -n ${NAMESPACE} -l app=ecommerce-api
    kubectl get svc -n ${NAMESPACE} ecommerce-api
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --build)
            BUILD_IMAGE="true"
            shift
            ;;
        --rollback)
            rollback
            exit 0
            ;;
        --help)
            echo "Usage: $0 [environment] [image_tag] [options]"
            echo "Options:"
            echo "  --build     Build and push Docker image"
            echo "  --rollback  Rollback to previous deployment"
            echo "  --help      Show this help message"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# Run main function
main
