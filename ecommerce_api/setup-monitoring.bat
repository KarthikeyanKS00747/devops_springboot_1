@echo off
echo Setting up Graphite and Grafana monitoring for E-commerce API...

echo.
echo Checking if Docker is installed...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from: https://docs.docker.com/desktop/install/windows-install/
    pause
    exit /b 1
)

echo Docker is installed!
echo.

echo Starting monitoring stack (Graphite + Grafana)...
docker-compose -f docker-compose.monitoring.yml up -d

echo.
echo Waiting for services to start...
timeout /t 30 /nobreak >nul

echo.
echo ========================================
echo MONITORING STACK SETUP COMPLETE!
echo ========================================
echo.
echo Services available at:
echo - Grafana Dashboard: http://localhost:3000
echo   Username: admin
echo   Password: admin123
echo.
echo - Graphite Web UI: http://localhost:8080
echo.
echo Your Spring Boot app should now send metrics to:
echo - Graphite: localhost:2003
echo.
echo To stop the monitoring stack, run:
echo docker-compose -f docker-compose.monitoring.yml down
echo.
pause
