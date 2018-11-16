FROM node
WORKDIR /usr/src/app
COPY ./ ./
RUN npm cache clean --force && npm install
expose 3000
ENTRYPOINT npm run start
