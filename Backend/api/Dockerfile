# Usa una imagen oficial de Node.js como base
FROM node:18

# Establece el directorio de trabajo
WORKDIR /app

# Copia el package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Exponer el puerto donde corre la aplicación
EXPOSE 3000

# Comando para correr la aplicación
CMD ["./app", "&&", "npm", "run", "dev"]
