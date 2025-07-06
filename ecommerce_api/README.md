# E-commerce REST API with DevOps CI/CD Pipeline

A comprehensive Spring Boot e-commerce REST API with enterprise-level DevOps practices including CI/CD pipeline, Infrastructure as Code, containerization, monitoring, and automated testing.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         DevOps Pipeline                        │
├─────────────────────────────────────────────────────────────────┤
│ Git → Jenkins → Build → Test → Security → Deploy → Monitor    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    Application Architecture                    │
├─────────────────────────────────────────────────────────────────┤
│ Frontend ← → Load Balancer ← → API Gateway ← → Spring Boot     │
│                                                  ↓              │
│                                              Database           │
│                                                  ↓              │
│                                                Cache            │
└─────────────────────────────────────────────────────────────────┘
```

## 🚀 Features

### Application Features
- **Product Management**: CRUD operations for products with categories, inventory tracking
- **User Management**: Registration, authentication, JWT-based authorization
- **Order Processing**: Complete order lifecycle with status tracking
- **Shopping Cart**: Add/remove items, calculate totals
- **Inventory Management**: Real-time stock updates
- **API Documentation**: OpenAPI 3.0/Swagger integration

### DevOps Features
- **CI/CD Pipeline**: Jenkins-based automated pipeline
- **Infrastructure as Code**: Terraform for AWS infrastructure
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes with auto-scaling
- **Monitoring**: Prometheus, Grafana, Jaeger tracing
- **Security**: OWASP dependency check, container scanning
- **Testing**: Unit, integration, and performance tests

## 🛠️ Technology Stack

### Backend
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: MySQL 8.0
- **Cache**: Redis
- **Security**: Spring Security + JWT
- **Testing**: JUnit 5, Testcontainers
- **Build Tool**: Maven 3.8+

### Infrastructure
- **Cloud Provider**: AWS
- **Container Platform**: Docker + Kubernetes (EKS)
- **Infrastructure**: Terraform
- **Configuration**: Ansible
- **CI/CD**: Jenkins
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack
- **Tracing**: Jaeger

## 📋 Prerequisites

- Java 17+
- Maven 3.8+
- Docker & Docker Compose
- AWS CLI configured
- kubectl
- Terraform
- Ansible

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ecommerce-api.git
   cd ecommerce-api
   ```

2. **Start infrastructure services**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

3. **Run the application**
   ```bash
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

4. **Access the application**
   - API: http://localhost:8080
   - Swagger UI: http://localhost:8080/swagger-ui.html
   - Actuator: http://localhost:8080/actuator

### Production Deployment

1. **Provision AWS Infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform plan -var-file="production.tfvars"
   terraform apply
   ```

2. **Deploy with Ansible**
   ```bash
   cd ansible
   ansible-playbook -i inventory deploy-infrastructure.yml
   ```

3. **Deploy Application**
   ```bash
   # Trigger Jenkins pipeline or manual deployment
   kubectl apply -f k8s/production/
   ```

## 📊 API Endpoints

### Authentication
```http
POST /api/auth/signup     # User registration
POST /api/auth/signin     # User login
```

### Products
```http
GET    /api/products           # Get all products
GET    /api/products/{id}      # Get product by ID
POST   /api/products           # Create product (Admin)
PUT    /api/products/{id}      # Update product (Admin)
DELETE /api/products/{id}      # Delete product (Admin)
GET    /api/products/search    # Search products
```

### Orders
```http
GET  /api/orders               # Get all orders (Admin)
GET  /api/orders/my-orders     # Get user's orders
POST /api/orders               # Create order
PUT  /api/orders/{id}/status   # Update order status (Admin)
PUT  /api/orders/{id}/cancel   # Cancel order
```

## 🧪 Testing

### Unit Tests
```bash
mvn test
```

### Integration Tests
```bash
mvn verify -P integration-tests
```

### Load Testing
```bash
# Using JMeter
jmeter -n -t performance-tests/load-test.jmx -l results.jtl
```

## 📈 Monitoring & Observability

### Metrics
- **Application Metrics**: Micrometer + Prometheus
- **Infrastructure Metrics**: Node Exporter, cAdvisor
- **Custom Business Metrics**: Order processing, user registration

### Dashboards
- **Grafana Dashboards**: 
  - Application performance
  - Infrastructure monitoring
  - Business metrics
  - JVM metrics

### Alerting
- **Critical Alerts**: Application down, high error rate
- **Warning Alerts**: High latency, memory usage
- **Business Alerts**: Low inventory, failed payments

### Tracing
- **Distributed Tracing**: Jaeger integration
- **Request Tracing**: End-to-end transaction visibility

## 🔒 Security

### Application Security
- JWT token-based authentication
- Role-based access control (RBAC)
- Input validation and sanitization
- SQL injection prevention
- XSS protection

### Infrastructure Security
- Network policies
- Security groups
- Secrets management
- Container image scanning
- Dependency vulnerability scanning

## 🚀 CI/CD Pipeline

### Pipeline Stages
1. **Checkout**: Source code retrieval
2. **Build**: Maven compilation
3. **Unit Tests**: JUnit test execution
4. **Integration Tests**: Testcontainers-based tests
5. **Code Quality**: SonarQube analysis
6. **Security Scan**: OWASP dependency check
7. **Package**: JAR creation
8. **Docker Build**: Container image creation
9. **Security Scan**: Container vulnerability scan
10. **Push**: Registry upload (ECR/Docker Hub)
11. **Deploy Staging**: Kubernetes deployment
12. **Smoke Tests**: Basic functionality verification
13. **Performance Tests**: Load testing
14. **Deploy Production**: Blue-green deployment
15. **Post-deployment**: Health checks and monitoring

### Quality Gates
- Unit test coverage > 80%
- Integration test coverage > 70%
- SonarQube quality gate passed
- No critical security vulnerabilities
- Performance benchmarks met

## 📁 Project Structure

```
ecommerce-api/
├── src/
│   ├── main/
│   │   ├── java/com/ecommerce/
│   │   │   ├── controller/         # REST controllers
│   │   │   ├── service/            # Business logic
│   │   │   ├── repository/         # Data access
│   │   │   ├── entity/             # JPA entities
│   │   │   ├── dto/                # Data transfer objects
│   │   │   ├── security/           # Security configuration
│   │   │   └── exception/          # Exception handling
│   │   └── resources/
│   │       ├── application*.properties
│   │       └── data.sql
│   └── test/
│       ├── java/                   # Test classes
│       └── resources/              # Test configuration
├── terraform/                      # Infrastructure as Code
├── ansible/                        # Configuration management
├── k8s/                           # Kubernetes manifests
├── docker/                        # Docker configurations
├── performance-tests/             # JMeter test plans
├── Dockerfile                     # Container definition
├── docker-compose*.yml           # Local development
├── Jenkinsfile                    # CI/CD pipeline
└── README.md
```

## 🌍 Environment Configuration

### Development
- In-memory H2 database
- Debug logging enabled
- Hot reload enabled
- Mock external services

### Staging
- MySQL database
- Redis cache
- Production-like configuration
- Limited resources

### Production
- High availability MySQL (RDS)
- Redis cluster (ElastiCache)
- Load balancing
- Auto-scaling
- Comprehensive monitoring

## 📝 Configuration Management

### Application Properties
```yaml
# Development
spring.profiles.active=dev
spring.datasource.url=jdbc:h2:mem:testdb

# Production
spring.profiles.active=prod
spring.datasource.url=${DB_URL}
management.metrics.export.prometheus.enabled=true
```

### Environment Variables
```bash
# Database
DB_URL=jdbc:mysql://localhost:3306/ecommerce_prod
DB_USERNAME=ecommerce_user
DB_PASSWORD=secure_password

# Security
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION=86400000

# Cache
REDIS_HOST=localhost
REDIS_PORT=6379
```

## 🔧 Development Setup

### IDE Configuration
1. **IntelliJ IDEA**: Import as Maven project
2. **VS Code**: Install Java Extension Pack
3. **Eclipse**: Import existing Maven project

### Code Style
- Google Java Style Guide
- Checkstyle configuration included
- PMD rules for code quality
- SpotBugs for bug detection

### Pre-commit Hooks
```bash
# Install pre-commit
pip install pre-commit
pre-commit install

# Manual run
pre-commit run --all-files
```

## 📊 Performance Benchmarks

### Target Metrics
- **Response Time**: < 200ms (95th percentile)
- **Throughput**: > 1000 RPS
- **Availability**: 99.9% uptime
- **Error Rate**: < 0.1%

### Load Testing Results
- **Concurrent Users**: 500
- **Test Duration**: 10 minutes
- **Average Response Time**: 150ms
- **Peak Throughput**: 1200 RPS

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection**
   ```bash
   # Check MySQL connectivity
   mysql -h localhost -u ecommerce_user -p
   ```

2. **Application Startup**
   ```bash
   # Check application logs
   kubectl logs -f deployment/ecommerce-api -n production
   ```

3. **Performance Issues**
   ```bash
   # Check resource usage
   kubectl top pods -n production
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Run quality checks
6. Submit a pull request

### Development Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and test
mvn clean test

# Run quality checks
mvn checkstyle:check spotbugs:check

# Commit and push
git commit -m "Add new feature"
git push origin feature/new-feature
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [Wiki](https://github.com/your-username/ecommerce-api/wiki)
- **Issues**: [GitHub Issues](https://github.com/your-username/ecommerce-api/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/ecommerce-api/discussions)

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- Kubernetes community for orchestration platform
- AWS for cloud infrastructure
- Open source community for various tools and libraries

---

**Built with ❤️ for demonstrating enterprise-level DevOps practices**
