# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install the app dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Svelte app for production
RUN npm run build

# Install a simple HTTP server to serve the built app
RUN npm install -g serve

# Expose port 80 to the outside world
EXPOSE 80

# Serve the app on port 80
CMD ["serve", "-s", "public", "-l", "80"]
