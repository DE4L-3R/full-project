# DevSecOps 프로젝트

## 프로젝트 개요
DevSecOps 방법론을 적용한 웹 애플리케이션 개발 및 운영 환경 구축 프로젝트입니다. 
보안을 고려한 CI/CD 파이프라인과 모니터링 시스템을 구축하여 안전하고 효율적인 개발 환경을 제공합니다.

## 기술 스택
- **컨테이너 오케스트레이션**: Kubernetes (Kind)
- **CI/CD**: Jenkins
- **코드 품질**: SonarQube
- **로깅 & 모니터링**: ELK Stack
- **웹 서비스**: Apache, PHP
- **버전 관리**: Git, GitHub

## 프로젝트 구조
```
.
├── docs/                    # 문서화 자료
│   ├── word/               # Word 문서
│   ├── pptx/               # PowerPoint 문서
│   ├── pdf/                # PDF 문서
│   └── md/                 # Markdown 문서
├── ELK/                    # ELK 스택
│   └── k8s/                # ELK 스택 Kubernetes 매니페스트
├── Jenkins/                # Jenkins CI/CD 서버
│   ├── k8s/                # Jenkins Kubernetes 매니페스트
│   └── pipeline/           # Jenkins 파이프라인 스크립트
├── SonarQube/             # SonarQube 코드 품질 검사
│   ├── k8s/                # SonarQube Kubernetes 매니페스트
│   └── config/             # SonarQube 설정 파일
├── Kubernetes/             # Kubernetes 클러스터 설정
│   ├── deploy.bat          # 클러스터 생성 스크립트
│   ├── kind-config.yaml    # Kind 클러스터 설정
│   └── reset-cluster.bat   # 클러스터 초기화 스크립트
└── Web/                    # 웹 애플리케이션
    ├── src/                # 소스 코드
    └── k8s/                # 웹 서비스 Kubernetes 매니페스트
```

## 컴포넌트 설명

### 1. Kubernetes 클러스터
- Kind를 사용한 로컬 Kubernetes 클러스터
- 3개의 워커 노드 구성
  - worker1: 웹 서비스 실행
  - worker2: Jenkins 실행
  - worker3: ELK 스택 실행

### 2. Jenkins CI/CD
- Docker Hub 이미지 변경 감지
- 자동 배포 파이프라인
- SonarQube 연동 코드 품질 검사
- Kubernetes 클러스터 배포 자동화

### 3. SonarQube
- 코드 품질 분석
- 보안 취약점 스캔
- Jenkins 파이프라인 연동
- 품질 게이트 설정

### 4. ELK 스택
- 중앙 집중식 로깅
- 실시간 모니터링
- 시각화 대시보드
- 보안 이벤트 감지

### 5. 웹 애플리케이션
- Apache/PHP 기반 웹 서비스
- 컨테이너화된 배포
- 자동 스케일링
- 보안 설정 적용

## 시작하기

### 사전 요구사항
- Docker Desktop
- Git
- Windows 운영체제

### 설치 및 실행

1. **클러스터 초기화 및 생성**:
```bash
cd Kubernetes
reset-cluster.bat
deploy.bat
```

2. **Jenkins 배포**:
```bash
cd ../Jenkins
jenkins-service.bat
```

3. **SonarQube 배포**:
```bash
cd ../SonarQube
sonarqube-service.bat
```

4. **ELK 스택 배포**:
```bash
cd ../ELK
ELK.bat
```

5. **웹 서비스 배포**:
```bash
cd ../Web
web-service.bat
```

## 접속 정보
- Jenkins: http://localhost:8080
- SonarQube: http://localhost:30900
- Kibana: http://localhost:5601
- 웹 서비스: http://localhost:30080

## 주의사항
1. Jenkins는 worker2 노드에서 실행
2. 웹 서비스는 worker1 노드에서 실행
3. ELK 스택은 worker3 노드에서 실행
4. 각 서비스의 데이터는 기본적으로 emptyDir 사용

## 참고 자료
- https://github.com/GH6679/web_wargamer.git (웹 서비스 소스)