version: '3.8'

services:
  mongodb:
    image: mongo:latest
    container_name: chess-mongodb
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
    volumes:
      - mongodb_data:/data/db
    networks:
      - chess-network

  chess-app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: chess-app
    restart: unless-stopped
    ports:
      - "5173:5173"
      - "9000:9000"
    environment:
      - NODE_ENV=production
      - MONGODB_URI=mongodb://admin:password@mongodb:27017/chess?authSource=admin
      - PORT=9000
    depends_on:
      - mongodb
    networks:
      - chess-network

volumes:
  mongodb_data:

networks:
  chess-network:
    driver: bridge