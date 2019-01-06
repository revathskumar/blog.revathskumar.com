FROM jekyll/jekyll:builder AS staticassets
RUN mkdir -p /code/_site
WORKDIR /code
COPY ./ ./
RUN jekyll build

FROM nginx:1.15-alpine
RUN apk add --no-cache bash libssl1.0 openssh bash
WORKDIR /usr/share/nginx/html
COPY --from=staticassets /code/_site ./
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]