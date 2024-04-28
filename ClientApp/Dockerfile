# ustawienie bazowego obrazu
FROM node

# ustawienie katalogu roboczego
WORKDIR /client-app

# kopiowanie
COPY package.json ./

# instalacja paczek
RUN npm install

# kopiowwanie
COPY . .

# nasłuchiwanie na porcie 3000
EXPOSE 5173

# komenda startowa
CMD ["npm", "run","dev"]