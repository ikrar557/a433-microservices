#!/bin/bash

# Membuat namespace
kubectl apply -f namespace.yml

# Memasang istio
istioctl install --set profile=demo -y
kubectl label namespace deployments istio-injection=enabled

# Menambahkan repository helm untuk rabbitmq
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Deploy RabbitMQ menggunakan Helm
helm install rabbitmq bitnami/rabbitmq \
  --namespace communications \
  --values rabbitmq/values.yaml

# Menunggu pod dari RabbitMQ siap
echo "Waiting for RabbitMQ to be ready..."
kubectl wait --namespace=communications --for=condition=ready pod -l app.kubernetes.io/name=rabbitmq --timeout=60s

# Deploy services setelah RabbitMQ berhasil dijalankan
echo "Deploying microservices..."
kubectl apply -f order-service/
kubectl apply -f shipping-service/

# Menunggu hingga semua services di jalankan
echo "Waiting for services to be ready..."
kubectl wait --namespace=deployments --for=condition=ready pod -l app=orderservice --timeout=30s
kubectl wait --namespace=deployments --for=condition=ready pod -l app=shippingservice --timeout=30s

# Deploy konfigurasi dari Istio
kubectl apply -f istio/

echo "Setup completed!"
echo "================================================================"
echo "You can access the services at:"
echo "----------------------------------------------------------------"
echo "Order Service (REST API):"
echo "  - http://localhost:30000/order"
echo
echo "Shipping Service (REST API):"
echo "  - http://localhost:30001"
echo
echo "RabbitMQ:"
echo "  - AMQP: amqp://user:password@localhost:30672"
echo "  - Management UI: http://localhost:31672"
echo "  - Username: user"
echo "  - Password: password"
echo "================================================================"