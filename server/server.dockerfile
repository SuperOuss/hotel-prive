# Use an official Node runtime as the base image
FROM node:20

# Set the working directory in the container to /server
WORKDIR /server

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm update && npm install

# Install PM2 globally within the container
RUN npm install pm2 -g

# Copy the rest of your server code to the working directory
COPY . .

# Make port 8080 available to the world outside this container
EXPOSE 8080

CMD ["pm2-runtime", "start", "npm", "--", "run", "server"]

