# Etapa 1: Build do frontend
FROM node:18 as build-frontend

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build

# Etapa 2: Servir frontend estático com Nginx
FROM nginx:stable-alpine

# Remove configuração default
RUN rm /etc/nginx/conf.d/default.conf

# Copia nginx customizado (que escuta na porta 8081)
COPY nginx.conf /etc/nginx/conf.d/

# Copia o build do Vue
COPY --from=build-frontend /app/dist /usr/share/nginx/html

# Expõe a porta correta
EXPOSE 8081

# Inicia o nginx
CMD ["nginx", "-g", "daemon off;"]
