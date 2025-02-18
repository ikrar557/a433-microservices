#!/bin/bash

# Menghapus konfigurasi Istio (Gateway dan VirtualService)
kubectl delete -f istio/

# Menghapus service dan deployment microservices
# Menghapus order service (deployment dan service)
kubectl delete -f order-service/
# Menghapus shipping service (deployment dan service)
kubectl delete -f shipping-service/

# Menghapus RabbitMQ StatefulSet dan Service
kubectl delete -f rabbitmq/

# Menunggu RabbitMQ pods untuk dihapus
echo "Waiting for RabbitMQ pods to be removed..."
kubectl wait --namespace=communications --for=delete pod -l app=rabbitmq --timeout=60s

# Menghapus namespace yang telah dibuat (deployments dan communications)
kubectl delete -f namespace.yml

echo "Cleanup completed!"