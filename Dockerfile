# Mengambil base image node versi 16 dari Docker Hub
FROM node:16-alpine

# Menentukan direktori kerja di dalam container
WORKDIR /app

# Menyalin package.json dan package-lock.json (jika ada) ke direktori kerja
COPY package*.json ./

# Menginstall dependensi Node.js yang diperlukan
RUN npm install

# Menyalin seluruh kode aplikasi ke dalam container
COPY . .

# Mengekspos port 3000 agar dapat di akses dari luar container
EXPOSE 3000

# Menjalankan aplikasi menggunakan perintah npm start
CMD ["npm", "start"]