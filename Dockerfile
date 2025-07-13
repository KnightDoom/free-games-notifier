# Use official Node.js image
FROM node:24-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install && npm audit fix

# Copy the rest of the app
COPY . .

# Build the app (if needed)
RUN npm run build || true

# Default configuration file path
VOLUME ["/app/config"]

# Start the app
CMD ["npm", "run", "build:start"]
