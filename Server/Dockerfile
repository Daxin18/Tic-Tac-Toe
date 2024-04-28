# ustawienie bazowego obrazu
FROM node

# ustawienie katalogu roboczego
WORKDIR /server

# kopiowanie
COPY package.json ./

# instalacja paczek
RUN npm install

# kopiowanie
COPY . .

# nasłuchiwanie na porcie 3000
EXPOSE 3000

# komenda startowa
CMD ["node", "server.js"]