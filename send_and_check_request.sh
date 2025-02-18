#!/bin/bash

# Input nama pembeli dari user
echo "Enter buyer name:"
read BUYER_NAME

# Mengirim request POST untuk membuat order baru
echo "1. Sending POST request to create an order..."
echo "--------------------------------------------"

# Mengirim HTTP POST request ke order service
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

sleep 1

# Memeriksa status antrian RabbitMQ
echo -e "\n\n2. Checking RabbitMQ Queue Status..."
echo "--------------------------------------------"

RABBITMQ_POD=$(kubectl get pods -n deployments -l app=rabbitmq -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n deployments $RABBITMQ_POD -- rabbitmqctl list_queues

# Memeriksa log shipping service
echo -e "\n\n3. Checking Shipping Service Logs..."
echo "--------------------------------------------"

# Mengambil log dari shipping service
kubectl logs -n deployments -l app=shippingservice --tail=20

echo -e "\nTest completed!"