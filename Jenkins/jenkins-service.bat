@echo off
echo Deploying Jenkins to Kubernetes...

REM Store the original directory
set "ORIGINAL_DIR=%CD%"

echo.
echo Creating devops namespace if not exists...
kubectl create namespace devops --dry-run=client -o yaml | kubectl apply -f -

echo.
echo Applying RBAC configurations...
kubectl apply -f "%~dp0k8s\jenkins-admin.yaml"
if %errorlevel% neq 0 (
    echo Failed to apply RBAC configuration
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Deploying Jenkins...
kubectl apply -f "%~dp0k8s\jenkins-deployment.yaml"
if %errorlevel% neq 0 (
    echo Failed to deploy Jenkins
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Applying Jenkins service...
kubectl apply -f "%~dp0k8s\jenkins-service.yaml"
if %errorlevel% neq 0 (
    echo Failed to create service
    cd "%ORIGINAL_DIR%"
    exit /b %errorlevel%
)

echo.
echo Waiting for Jenkins pod to be ready...
:wait_pod
for /f "tokens=1,2,3 delims= " %%a in ('kubectl get pods -l app^=jenkins -n devops ^| findstr "jenkins"') do (
    set "POD_NAME=%%a"
    set "READY=%%b"
    set "STATUS=%%c"
)
if "%STATUS%"=="Running" (
    goto :pod_ready
)
echo Current status: %READY% containers ready ^| Pod status: %STATUS%
echo Waiting for Jenkins to be ready...
timeout /t 5 /nobreak > nul
goto :wait_pod

:pod_ready
echo.
echo Jenkins pod is ready!

echo.
echo Getting Jenkins initial admin password...
for /f "tokens=1" %%i in ('kubectl get pods -l app^=jenkins -n devops -o jsonpath^="{.items[0].metadata.name}"') do (
    echo Initial admin password:
    kubectl exec -n devops %%i -- cat /var/jenkins_home/secrets/initialAdminPassword
)

echo.
echo Setting up port-forward for Jenkins...
start /B kubectl port-forward svc/jenkins -n devops 8080:8080

echo.
echo Jenkins is available at http://localhost:8080
echo Please configure the following:
echo 1. Install suggested plugins
echo 2. Create admin user
echo 3. Create a new pipeline with the following settings:
echo    - Name: wargame-web-deploy
echo    - Type: Pipeline
echo    - Pipeline script from SCM
echo    - SCM: Git
echo    - Repository URL: https://github.com/kimbeomjun90/devsecops_full.git
echo    - Script Path: Jenkins/pipeline/Jenkinsfile

cd "%ORIGINAL_DIR%"
endlocal
