# Jenkins 설정 가이드

## 사전 준비사항

- Kubernetes 클러스터 구성 (kind)
- kubectl 설정 완료
- Docker Hub 이미지 저장소

## 디렉토리 구조

```
Jenkins/
├── k8s/
│   ├── jenkins-deployment.yaml  # Jenkins 배포 설정
│   ├── jenkins-service.yaml     # Jenkins 서비스 설정
│   ├── jenkins-admin.yaml      # RBAC 권한 설정
│   ├── jenkins-config.yaml     # Jenkins 추가 설정 (선택)
│   └── ngrok-secret.yaml       # GitHub 웹훅용 (선택)
├── pipeline/
│   └── Jenkinsfile            # CI/CD 파이프라인 정의
└── jenkins-service.bat         # Jenkins 서비스 실행 스크립트
```

## 설치 및 실행

### Jenkins 배포
```bash
jenkins-service.bat
```

## Jenkins 접속

- 웹 UI: http://localhost:8080

## 초기 설정

1. 관리자 비밀번호 확인:
   ```bash
   kubectl exec -n devops $(kubectl get pods -n devops -l app=jenkins -o jsonpath="{.items[0].metadata.name}") -- cat /var/jenkins_home/secrets/initialAdminPassword
   ```

2. 웹 UI 접속 후 초기 설정:
   - "Install suggested plugins" 선택
   - 관리자 계정 생성
   - 새 파이프라인 생성:
     - 이름: wargame-web-deploy
     - 타입: Pipeline
     - Pipeline script from SCM 선택
     - Git 선택
     - Repository URL: https://github.com/kimbeomjun90/devsecops_full.git
     - Script Path: Jenkins/pipeline/Jenkinsfile

## 파이프라인 기능

1. Docker Hub 이미지 변경 감지
2. 변경 감지시 자동으로 Web 서비스 배포
3. SonarQube 연동 코드 품질 검사

## 주의사항

1. Jenkins는 worker2 노드에서 실행 (SonarQube와 함께)
2. Jenkins 데이터는 기본적으로 emptyDir 볼륨 사용
3. 필요시 PV/PVC 설정으로 데이터 영구 저장 가능
