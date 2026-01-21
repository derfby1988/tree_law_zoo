#!/bin/bash

# Kill WebSocket Server Script
# Kills any process using port 3000

PORT=${1:-3000}

echo "🔍 Checking for processes on port $PORT..."

PID=$(lsof -ti:$PORT)

if [ -z "$PID" ]; then
    echo "✅ No process found on port $PORT"
else
    echo "Found process(es): $PID"
    echo "Killing process(es)..."
    kill -9 $PID 2>/dev/null
    sleep 1
    
    # Verify
    if lsof -ti:$PORT > /dev/null 2>&1; then
        echo "⚠️  Some processes might still be running"
    else
        echo "✅ Port $PORT is now free"
    fi
fi

# Also kill nodemon processes
NODEMON_PIDS=$(ps aux | grep -i "nodemon.*server" | grep -v grep | awk '{print $2}')
if [ ! -z "$NODEMON_PIDS" ]; then
    echo "Killing nodemon processes: $NODEMON_PIDS"
    kill -9 $NODEMON_PIDS 2>/dev/null
fi

echo "Done!"
