FROM node:16.14.0 as node

WORKDIR /app

# Kopyala sadece package.json dosyasını
COPY src/package.json .

# package.json'daki bağımlılıkları yükle
RUN npm install

# Tüm proje dosyalarını kopyala
COPY . .

RUN npm run build --prod

# Stage 2
FROM nginx:alpine
# Yerelde bulunan default.conf dosyasını /tmp dizinine kopyala
COPY src/nginx/etc/conf.d/default.conf /tmp/default.conf
RUN sed -i 's/localhost/myapp-backend-service/g' /tmp/default.conf
RUN mv /tmp/default.conf /etc/nginx/conf.d/default.conf
COPY --from=node /app/dist/myapp-frontend /usr/share/nginx/html




#COPY src/nginx/etc/conf.d/default.conf /etc/nginx/conf.d/default.conf