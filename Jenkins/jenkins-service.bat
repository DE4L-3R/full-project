@echo off
chcp 65001 > nul

REM Store the original directory
set "ORIGINAL_DIR=%CD%"

echo Jenkins 서비스 배포 중...

REM Create namespace if it doesn't exist
kubectl create namespace devops 2>nul

REM Create service account and RBAC resources
kubectl apply -f k8s/jenkins-admin.yaml

REM Apply Kubernetes configurations
kubectl apply -f k8s/jenkins-deployment.yaml
kubectl apply -f k8s/jenkins-service.yaml

echo.
echo Jenkins Pod 준비 상태 확인 중...
:wait_pod
for /f "tokens=1,2,3 delims= " %%a in ('kubectl get pods -l app^=jenkins -n devops ^| findstr "jenkins"') do (
    set "POD_NAME=%%a"
    set "READY=%%b"
    set "STATUS=%%c"
)
if "%STATUS%"=="Running" (
    goto :pod_ready
)
echo 현재 상태: %READY% 컨테이너 준비됨 ^| Pod 상태: %STATUS%
echo Jenkins 준비 중...
timeout /t 5 /nobreak > nul
goto :wait_pod

:pod_ready
echo.
echo Jenkins Pod가 준비되었습니다!

echo.
echo Jenkins 서비스가 배포되었습니다:
echo - NodePort 접속 주소: http://localhost:30800
echo - JNLP 포트: 30850 (Jenkins 에이전트 연결용)
echo.
echo.
:check_password
echo 초기 패스워드 확인 중...
for /f "tokens=1" %%i in ('kubectl get pods -l app^=jenkins -n devops -o jsonpath^="{.items[0].metadata.name}"') do (
    kubectl exec -n devops %%i -- cat /var/jenkins_home/secrets/initialAdminPassword > password.tmp 2>nul
    if exist password.tmp (
        set /p INITIAL_PASSWORD=<password.tmp
        del password.tmp
        goto :password_found
    )
)
echo 초기 패스워드를 가져오는 중입니다. Jenkins 초기화가 완료되지 않았을 수 있습니다.
timeout /t 5 > nul
goto :check_password

:password_found
echo 초기 패스워드: %INITIAL_PASSWORD%

echo.
echo 다음 단계를 진행해주세요:
echo 1. 추천 플러그인 설치
echo 2. 관리자 계정 생성
echo 3. 새 파이프라인 생성:
echo    - 이름: wargame-web-deploy
echo    - 유형: Pipeline
echo    - Pipeline script from SCM
echo    - SCM: Git
echo    - Repository URL: https://github.com/DE4L-3R/full-project.git
echo    - Script Path: Jenkins/pipeline/Jenkinsfile

cd /d "%ORIGINAL_DIR%"
