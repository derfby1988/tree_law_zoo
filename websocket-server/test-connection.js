/**
 * Test Script for WebSocket Server
 * Run: node test-connection.js
 */

const io = require('socket.io-client');

const serverUrl = process.env.SERVER_URL || 'http://localhost:3000';

console.log(`🔌 Connecting to WebSocket Server: ${serverUrl}`);

const socket = io(serverUrl, {
  transports: ['websocket'],
});

socket.on('connect', () => {
  console.log('✅ Connected to server');
  console.log(`Socket ID: ${socket.id}`);
  
  // Test: Send user connected
  socket.emit('user-connected', { userId: 'test-user-123' });
  console.log('📤 Sent: user-connected');
  
  // Test: Send location update
  setTimeout(() => {
    socket.emit('location-update', {
      userId: 'test-user-123',
      latitude: 13.7563,
      longitude: 100.5018,
      timestamp: new Date().toISOString(),
      accuracy: 10.5,
    });
    console.log('📤 Sent: location-update');
  }, 1000);
  
  // Test: Subscribe to user
  setTimeout(() => {
    socket.emit('subscribe-user', { userId: 'test-user-123' });
    console.log('📤 Sent: subscribe-user');
  }, 2000);
});

socket.on('connect_error', (error) => {
  console.error('❌ Connection error:', error.message);
  console.log('\n💡 Make sure the server is running:');
  console.log('   npm start');
  process.exit(1);
});

socket.on('location-updated', (data) => {
  console.log('📥 Received: location-updated');
  console.log('   Data:', JSON.stringify(data, null, 2));
});

socket.on('user-online', (data) => {
  console.log('📥 Received: user-online');
  console.log('   Data:', JSON.stringify(data, null, 2));
});

socket.on('error', (error) => {
  console.error('❌ Error:', error);
});

socket.on('disconnect', () => {
  console.log('🔌 Disconnected from server');
});

// Cleanup after 5 seconds
setTimeout(() => {
  console.log('\n✅ Test completed');
  socket.disconnect();
  process.exit(0);
}, 5000);
