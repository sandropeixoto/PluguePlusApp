FROM ghcr.io/cirruslabs/flutter:3.24.0 as build
WORKDIR /app
COPY pubspec.yaml .
RUN flutter config --enable-web
RUN flutter pub get
COPY . .
RUN flutter pub get
RUN flutter build web --release --source-maps

FROM nginx:1.27-alpine
ENV PORT=8080
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 8080
