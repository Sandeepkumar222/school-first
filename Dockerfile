# Stage 1: Build React App
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app for production
RUN npm run build

# --------------------------------------------------------

# Stage 2: Serve React App with NGINX
FROM nginx:stable-alpine AS production

# Copy the React build from builder stage to NGINX's default HTML directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX when container runs
CMD ["nginx", "-g", "daemon off;"]
