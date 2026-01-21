#!/bin/bash

# Test Health Check Endpoint
# Usage: ./test-health.sh [port]

PORT=${1:-3000}
URL="http://localhost:${PORT}/health"

echo "🔍 Testing WebSocket Server Health Check..."
echo "URL: $URL"
echo ""

response=$(curl -s -w "\n%{http_code}" "$URL" 2>/dev/null)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$http_code" = "200" ]; then
    echo "✅ Server is running!"
    echo "Response:"
    echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
else
    echo "❌ Server is not responding"
    echo "HTTP Code: $http_code"
    echo ""
    echo "💡 Make sure the server is running:"
    echo "   cd websocket-server"
    echo "   npm start"
fi
