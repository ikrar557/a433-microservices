# Mengambil base image node versi 14 dari Docker Hub
FROM node:14-alpine

# Membuat 'directory kerja' di dalam container untuk menaruh aplikasi
WORKDIR /app

# Menyalin seluruh file dan direktori dari host ke dalam container
COPY . /app/

# Mendifinisikan variabel environment untuk production dan menggunakan container bernama 'item-db' sebagai database host
ENV NODE_ENV=production DB_HOST=item-db

# Menginstall dependencies dan menjalankan build untuk aplikasi
RUN npm install --production --unsafe-perm && npm run build

# Mengekspos port 8080 untuk aplikasi agar dapat diakses dari luar container
EXPOSE 8080

# Menjalankan aplikasi menggunakan perintah "npm"
CMD [ "npm", "start" ]