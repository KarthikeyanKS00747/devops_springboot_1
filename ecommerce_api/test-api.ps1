# PowerShell script to test E-commerce API endpoints and generate metrics

Write-Host "Testing E-commerce API Endpoints..." -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

$baseUrl = "http://localhost:8081"

# Test Products endpoint
Write-Host "`n1. Testing Products API..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api/products" -Method GET -Headers @{"Accept"="application/json"}
    Write-Host "✅ Products API - Status: $($response.StatusCode)" -ForegroundColor Green
    $products = $response.Content | ConvertFrom-Json
    Write-Host "   Found $($products.content.Length) products" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Products API failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Health endpoint
Write-Host "`n2. Testing Health endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/actuator/health" -Method GET
    Write-Host "✅ Health endpoint - Status: $($response.StatusCode)" -ForegroundColor Green
    $health = $response.Content | ConvertFrom-Json
    Write-Host "   Application status: $($health.status)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Health endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Metrics endpoint
Write-Host "`n3. Testing Metrics endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/actuator/metrics" -Method GET
    Write-Host "✅ Metrics endpoint - Status: $($response.StatusCode)" -ForegroundColor Green
    $metrics = $response.Content | ConvertFrom-Json
    Write-Host "   Available metrics: $($metrics.names.Length)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Metrics endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test H2 Console
Write-Host "`n4. Testing H2 Console..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/h2-console" -Method GET
    Write-Host "✅ H2 Console - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ H2 Console failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=================================" -ForegroundColor Green
Write-Host "API Testing Complete!" -ForegroundColor Green
Write-Host "`nAccess URLs:" -ForegroundColor White
Write-Host "- API: http://localhost:8081/api/products" -ForegroundColor Cyan
Write-Host "- Health: http://localhost:8081/actuator/health" -ForegroundColor Cyan
Write-Host "- Metrics: http://localhost:8081/actuator/metrics" -ForegroundColor Cyan
Write-Host "- H2 Console: http://localhost:8081/h2-console" -ForegroundColor Cyan
Write-Host "- Grafana: http://localhost:3000 (admin/admin123)" -ForegroundColor Cyan
Write-Host "- Graphite: http://localhost:8080" -ForegroundColor Cyan
