WORKDIR /app

# Copy the entire project
COPY . .

# Navigate to server and install dependencies
WORKDIR /app/server

# Install server dependencies
RUN npm ci

# Stage 3: Production image
FROM node:18-alpine

WORKDIR /app

# Install serve to serve the client build
RUN npm install -g serve

# Copy server files from build stage
COPY --from=server-build /app/server ./server

# Copy client build from build stage
COPY --from=client-build /app/client/dist ./client/dist

# Create a startup script
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'cd /app/server && node index.js &' >> /app/start.sh && \
    echo 'cd /app/client/dist && serve -s . -l 5173' >> /app/start.sh && \
    echo 'wait' >> /app/start.sh && \
    chmod +x /app/start.sh

# Expose ports (5173 for client, 9000 for server)
EXPOSE 5173
EXPOSE 9000

# Set environment variables
ENV NODE_ENV=production

# Start both client and server
CMD ["/app/start.sh"]