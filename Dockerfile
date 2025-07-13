# Use official Node.js Alpine image
FROM node:24-alpine

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install && npm audit fix

# Copy the rest of the app
COPY . .

# Ensure correct permissions (optional, often unnecessary)
RUN mkdir -p /app/dist /app/config \
    && chown -R node:node /app

# Use existing non-root user (UID 1000)
USER node

# Define volume
VOLUME ["/app/config"]

# Build (optional)
RUN npm run build || true

# Start the app
CMD ["npm", "run", "build:start"]
