# Etapa 1: Build do frontend
FROM node:18 as build-frontend

WORKDIR /app

# Copia arquivos de dependência para cache
COPY package.json yarn.lock ./

# Instala dependências usando Yarn
RUN yarn install --frozen-lockfile

# Copia o restante do código
COPY . .

# Build de produção do Vue
RUN yarn build


# Etapa 2: Servir frontend estático com Nginx
FROM nginx:stable-alpine

# Remove configuração default do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia configuração customizada do nginx
COPY nginx.conf /etc/nginx/conf.d/

# Copia build do frontend para o diretório padrão do Nginx
COPY --from=build-frontend /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
