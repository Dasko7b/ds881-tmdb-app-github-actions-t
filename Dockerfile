FROM node:20-alpine AS builder

WORKDIR /app

ARG EXPO_PUBLIC_TMDB_API_KEY
ENV EXPO_PUBLIC_TMDB_API_KEY=$EXPO_PUBLIC_TMDB_API_KEY

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN npx expo export --platform web --output-dir dist

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
