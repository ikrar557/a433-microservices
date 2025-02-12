#!/bin/bash

echo "Removing Prometheus..."
helm uninstall prometheus -n monitoring --wait
echo "Removing Grafana..."
helm uninstall grafana -n monitoring --wait

echo "Waiting for monitoring pods to be removed..."
kubectl wait --for=delete pod -l app=prometheus -n monitoring --timeout=60s 2>/dev/null || true
kubectl wait --for=delete pod -l app=grafana -n monitoring --timeout=60s 2>/dev/null || true

echo "Removing Frontend..."
kubectl delete -f frontend/karsajobs-ui-service.yml
kubectl delete -f frontend/karsajobs-ui-deployment.yml

echo "Removing Backend..."
kubectl delete -f backend/karsajobs-service.yml
kubectl delete -f backend/karsajobs-deployment.yml

echo "Removing MongoDB..."
kubectl delete -f mongodb/mongo-statefulset.yml
kubectl delete -f mongodb/mongo-service.yml
kubectl delete -f mongodb/mongo-pv-pvc.yml
kubectl delete -f mongodb/mongo-secret.yml
kubectl delete -f mongodb/mongo-configmap.yml

echo "Removing namespaces..."
kubectl delete -f namespace.yml

echo "Cleanup complete!"