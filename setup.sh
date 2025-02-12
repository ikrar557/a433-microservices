#!/bin/bash

echo "Creating namespaces..."
kubectl apply -f namespace.yml

echo "Deploying MongoDB..."
kubectl apply -f mongodb/mongo-configmap.yml
kubectl apply -f mongodb/mongo-secret.yml
kubectl apply -f mongodb/mongo-pv-pvc.yml
kubectl apply -f mongodb/mongo-service.yml
kubectl apply -f mongodb/mongo-statefulset.yml

echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb -n deployments --timeout=120s

echo "Deploying Backend..."
kubectl apply -f backend/karsajobs-deployment.yml
kubectl apply -f backend/karsajobs-service.yml

echo "Waiting for Backend to be ready..."
kubectl wait --for=condition=ready pod -l app=karsajobs -n deployments --timeout=120s

# Deploy Frontend
echo "Deploying Frontend..."
kubectl apply -f frontend/karsajobs-ui-deployment.yml
kubectl apply -f frontend/karsajobs-ui-service.yml

echo "Setting up monitoring..."

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --set alertmanager.persistentVolume.enabled=false \
  --set server.persistentVolume.enabled=false

helm install grafana grafana/grafana \
  --namespace monitoring \
  --set persistence.enabled=false

kubectl apply -f monitoring/monitoring-service.yml

echo "Setup complete! Access information:"
echo "Frontend: http://localhost:30080"
echo "Backend: http://localhost:30081"
echo "Prometheus: http://localhost:30090"
echo "Grafana: http://localhost:30091"
echo "Grafana admin password:"
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
echo