#!/bin/bash

# Start WebSocket Server Script

echo "🚀 Starting WebSocket Server..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found"
    echo "   Please run: ./setup.sh first"
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Check if node_modules exists
if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start server
echo "Starting server on port ${PORT:-3000}..."
npm start
