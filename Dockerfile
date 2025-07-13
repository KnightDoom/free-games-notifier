# Use official Node.js image (Alpine-based)
FROM node:24-alpine

# Create a non-root user with UID 1000 and group 1000
RUN addgroup -g 1000 appgroup && adduser -D -u 1000 -G appgroup appuser

# Set working directory
WORKDIR /app

# Copy package.json files and install dependencies
COPY package*.json ./
RUN npm install && npm audit fix

# Copy the rest of the app
COPY . .

# Create directories and fix permissions
RUN mkdir -p /app/dist /app/config \
    && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Define volume for config
VOLUME ["/app/config"]

# Run the build (optional — allow it to fail without crashing container)
RUN npm run build || true

# Start the app
CMD ["npm", "run", "build:start"]
