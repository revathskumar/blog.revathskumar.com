FROM jekyll/jekyll:builder AS staticassets
RUN mkdir -p /code/_site
WORKDIR /code
COPY ./ ./
RUN jekyll build

FROM nginx:1.15-alpine
WORKDIR /usr/share/nginx/html
COPY --from=staticassets /code/_site ./
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
