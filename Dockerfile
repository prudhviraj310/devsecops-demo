# Use official Node image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Copy package files and install deps
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Expose port & run app
EXPOSE 3000
CMD [ "npm", "run", "dev" ]
