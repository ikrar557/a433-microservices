#!/bin/bash

# Create namespaces
kubectl apply -f namespace.yml

# Install Istio
istioctl install --set profile=demo -y
kubectl label namespace deployments istio-injection=enabled

# Add Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Download wait-for-it script
curl -o wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
chmod +x wait-for-it.sh

# Deploy RabbitMQ using Helm
helm install rabbitmq bitnami/rabbitmq \
  --namespace communications \
  --values rabbitmq/values.yaml

# Wait for RabbitMQ pod to be ready
echo "Waiting for RabbitMQ pod to be ready..."
kubectl wait --namespace=communications --for=condition=ready pod -l app.kubernetes.io/name=rabbitmq --timeout=30s

# Get RabbitMQ service IP
RABBITMQ_HOST=$(kubectl get svc -n communications rabbitmq -o jsonpath='{.spec.clusterIP}')

# Wait for RabbitMQ service to be ready using wait-for-it.sh
echo "Waiting for RabbitMQ service to be ready..."
./wait-for-it.sh $RABBITMQ_HOST:5672 -t 30 -- echo "RabbitMQ AMQP port is available"
./wait-for-it.sh $RABBITMQ_HOST:15672 -t 30 -- echo "RabbitMQ Management port is available"

# Deploy services
kubectl apply -f order-service/
kubectl apply -f shipping-service/

# Deploy Istio configurations
kubectl apply -f istio/

# Cleanup wait-for-it script
rm wait-for-it.sh

echo "Setup completed!"