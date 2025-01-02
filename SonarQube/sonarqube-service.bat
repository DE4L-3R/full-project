@echo off
echo Deploying SonarQube to Kubernetes...

kubectl apply -f k8s/sonarqube-deployment.yaml
kubectl apply -f k8s/sonarqube-service.yaml

echo Waiting for SonarQube to be ready...
kubectl wait --for=condition=ready pod -l app=sonarqube -n devops --timeout=300s

echo SonarQube is available at http://localhost:30900
echo Default credentials: admin/admin