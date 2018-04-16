FROM node

RUN  mkdir /app
WORKDIR /app
ADD . /app/

RUN npm install -g vue-cli cross-env
RUN npm install

EXPOSE 8080