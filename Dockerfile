# Etapa 1: Build do frontend
FROM node:18 as build-frontend

WORKDIR /app

# Copia package.json e package-lock.json pra cache do npm install
COPY package*.json ./

RUN npm ci

# Copia o código frontend
COPY . .

# Build de produção do Vue
RUN npm run build


# Etapa 2: Servir frontend estático com Nginx
FROM nginx:stable-alpine

# Remove configuração default do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia configuração customizada do nginx (explico abaixo)
COPY nginx.conf /etc/nginx/conf.d/

# Copia build frontend para diretório padrão do nginx
COPY --from=build-frontend /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
