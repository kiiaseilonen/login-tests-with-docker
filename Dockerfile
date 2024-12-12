FROM node:16-alpine

WORKDIR /app

COPY ./package*.json ./

RUN npm install

COPY ./app ./app
COPY ./app/views ./app/views
COPY ./test ./test

RUN apk add --no-cache python3 py3-pip curl

RUN pip3 install robotframework selenium robotframework-seleniumlibrary

RUN apk update && apk add --no-cache \
    firefox

RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.35.0/geckodriver-v0.35.0-linux64.tar.gz \
    && tar -xzf geckodriver-v0.35.0-linux64.tar.gz \
    && mv geckodriver /usr/bin/ \
    && chmod +x /usr/bin/geckodriver \
    && rm geckodriver-v0.35.0-linux64.tar.gz

ENV DISPLAY=:99
ENV MOZ_HEADLESS=1

EXPOSE 5000

CMD ["npm", "start"]

