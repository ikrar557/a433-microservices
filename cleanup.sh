#!/bin/bash

# Menghapus konfigurasi Istio (Gateway dan VirtualService)
kubectl delete -f istio/

# Menghapus service dan deployment microservices
# Menghapus order service (deployment dan service)
kubectl delete -f order-service/
# Menghapus shipping service (deployment dan service)
kubectl delete -f shipping-service/

# Menghapus RabbitMQ menggunakan Helm
helm uninstall rabbitmq --namespace communications

# Menghapus namespace yang telah dibuat (deployments dan communications)
kubectl delete -f namespace.yml

echo "Cleanup completed!"