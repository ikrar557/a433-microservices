#!/bin/bash

# Prompt for buyer name
echo "Enter buyer name:"
read BUYER_NAME

echo "1. Sending POST request to create an order..."
echo "--------------------------------------------"

curl -X POST http://localhost:30000/order \
  -H "Content-Type: application/json" \
  -d '{
    "order": {
        "book_name": "Harry Potter",
        "author": "J.K Rowling",
        "buyer": "'"$BUYER_NAME"'",
        "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
    }
}'

echo -e "\n\n2. Checking RabbitMQ Queue Status..."
echo "--------------------------------------------"

# Get RabbitMQ pod name
RABBITMQ_POD=$(kubectl get pods -n communications -l app.kubernetes.io/name=rabbitmq -o jsonpath='{.items[0].metadata.name}')

# Check queue status
kubectl exec -n communications $RABBITMQ_POD -- rabbitmqctl list_queues

echo -e "\n\n3. Checking Shipping Service Logs..."
echo "--------------------------------------------"

# Get shipping service logs
kubectl logs -n deployments -l app=shippingservice --tail=20

echo -e "\nTest completed!"