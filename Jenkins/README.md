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
│   ├── jenkins-pv.yaml         # 영구 스토리지 설정 (선택)
│   ├── jenkins-config.yaml     # Jenkins 추가 설정 (선택)
│   ├── jenkins-ingress.yaml    # Ingress 설정 (선택)
│   └── ngrok-secret.yaml       # Ngrok 인증 정보 (선택)
├── pipeline/
│   └── Jenkinsfile            # CI/CD 파이프라인 정의
└── jenkins-service.bat         # Jenkins 서비스 실행 스크립트
```

## 설치 및 실행

### 1. 클러스터 준비
```bash
cd Kubernetes
deploy.bat
```

### 2. Jenkins 배포

#### 자동 배포 (권장)
```bash
cd Jenkins
jenkins-service.bat
```

#### 수동 배포
```bash
kubectl apply -f k8s/jenkins-admin.yaml
kubectl apply -f k8s/jenkins-deployment.yaml
kubectl apply -f k8s/jenkins-service.yaml
```

## Jenkins 접속

### 로컬 접속
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
3. Web 서비스는 worker1 노드에 배포됨

## 주의사항

1. Jenkins는 worker2 노드에서 실행됨
2. Web 서비스는 worker1 노드에서 실행됨
3. Jenkins 데이터는 기본적으로 emptyDir 볼륨 사용 (Pod 재시작시 초기화)
4. 필요시 PV/PVC 설정으로 데이터 영구 저장 가능

## 선택적 기능

추가 기능이 필요한 경우 다음 파일들을 활용할 수 있습니다:
1. jenkins-pv.yaml: 데이터 영구 저장
2. jenkins-config.yaml: Jenkins 추가 설정
3. jenkins-ingress.yaml: Ingress 설정
4. ngrok-secret.yaml: GitHub 웹훅 설정
