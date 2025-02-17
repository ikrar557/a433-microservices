#!/bin/bash

# Delete Istio configurations
kubectl delete -f istio/

# Delete services
kubectl delete -f order-service/
kubectl delete -f shipping-service/

# Uninstall RabbitMQ Helm release
helm uninstall rabbitmq --namespace communications

# Delete namespaces
kubectl delete -f namespace.yml

echo "Cleanup completed!"