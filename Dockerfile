# Käytä Node.js peruskuvaa
FROM node:16-alpine

# Määritä työhakemisto
WORKDIR /app

# Kopioi package.json ja package-lock.json
COPY ./package*.json ./

# Asenna Node.js riippuvuudet
RUN npm install

# Kopioi sovellustiedostot (views, app.js, public ja test)
COPY ./app ./app
COPY ./app/views ./app/views
COPY ./test ./test

# Asenna Python ja pip
RUN apk add --no-cache python3 py3-pip

# Asenna Robot Framework, Selenium ja SeleniumLibrary
RUN pip3 install robotframework selenium robotframework-seleniumlibrary

# Asenna Firefox ja geckodriver
RUN apk update && apk add --no-cache \
    firefox

RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.35.0/geckodriver-v0.35.0-linux64.tar.gz \
    && tar -xzf geckodriver-v0.35.0-linux64.tar.gz \
    && mv geckodriver /usr/bin/ \
    && chmod +x /usr/bin/geckodriver \
    && rm geckodriver-v0.35.0-linux64.tar.gz

# Aseta ympäristömuuttuja, jotta Selenium löytää Firefoxin
ENV DISPLAY=:99
ENV MOZ_HEADLESS=1

# Aseta portti, jota sovellus käyttää
EXPOSE 5000

CMD ["sh", "-c", "npm start & robot /app/test/tests/login_test.robot"]

