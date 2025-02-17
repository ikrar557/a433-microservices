# Menambahkan 'shebang' pada awal script
#!/bin/bash

# Membuat docker image dari Dockerfile yang sudah dibuat 
docker build -t shippingservice:latest .

# Melihat daftar docker image secara lokal
docker images

# Mengubah nama image agar sesuai dengan format Github Packages
docker tag shippingservice:latest ghcr.io/ikrar557/shippingservice:latest

# Mengambil token `Github` yang sebelumnya sudah di definisikan melalui perintah 'export'.
# Kemudian melakukan autentikasi menggunakan token `Github` agar dapat mengunggah image ke 'Github Packages'
echo $GITHUB_PAT | docker login ghcr.io -u ikrar557 --password-stdin

# Mengunggah image 'item-app' ke Github Packages
docker push ghcr.io/ikrar557/shippingservice:latest