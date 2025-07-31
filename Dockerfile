# Use official Node.js base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies and global serve tool
RUN npm install && npm install -g serve

# Copy the rest of the source code
COPY . .

# Build the Vite app
RUN npm run build

# Expose the port used by serve (Vite's preview is 4173 by default)
EXPOSE 4173

# Serve the production build
CMD ["serve", "-s", "dist", "-l", "4173"]
