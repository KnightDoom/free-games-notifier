# Use official Node.js Alpine-based image
FROM node:24-alpine

# Set working directory
WORKDIR /app

# Copy package.json files and install dependencies
COPY package*.json ./
RUN npm install --production && npm audit fix

# Copy the full app source
COPY . .

# Build the app (once, during image build)
RUN npm run build

# Create a non-root user (assuming UID 1000 already exists in base image as `node`)
RUN mkdir -p /app/config && chown -R node:node /app

# Switch to the node user (UID 1000, GID 1000)
USER node

# Config volume
VOLUME ["/app/config"]

# Start the app (do not rebuild at runtime)
CMD ["npm", "run", "start"]
