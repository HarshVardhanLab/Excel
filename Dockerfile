# Use Node.js 20 LTS
FROM node:20-alpine

# Install system dependencies for canvas
RUN apk add --no-cache \
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    pixman-dev \
    pangomm-dev \
    libjpeg-turbo-dev \
    freetype-dev

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy app source
COPY . .

# Create Database directory
RUN mkdir -p Database

# Expose health check port
EXPOSE 3000

# Start the bot
CMD ["npm", "start"]
