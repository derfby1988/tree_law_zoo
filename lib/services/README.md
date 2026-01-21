# Services Documentation

## WebSocket Service

Service สำหรับเชื่อมต่อกับ WebSocket Server เพื่อรับ-ส่งข้อมูลแบบ real-time

### Usage:

```dart
// Initialize service
final webSocketService = WebSocketService(
  serverUrl: 'http://your-server.com:3000',
);

// Connect to server
await webSocketService.connect(
  userId: 'user123',
  authToken: 'your-auth-token',
);

// Listen to location updates
webSocketService.locationStream.listen((locationData) {
  print('Location updated: ${locationData['userId']}');
  // Update map marker
});

// Send location update
webSocketService.sendLocation(
  userId: 'user123',
  latitude: 13.7563,
  longitude: 100.5018,
);

// Subscribe to specific user
webSocketService.subscribeToUser('other-user-id');

// Disconnect
webSocketService.disconnect();
```

## Location Tracking Service

Service สำหรับติดตามตำแหน่ง GPS และส่งไปยัง WebSocket Server

### Usage:

```dart
// Initialize service
final locationService = LocationTrackingService();

// Check permissions
final hasPermission = await locationService.checkPermissions();

// Start tracking
await locationService.startTracking(
  userId: 'user123',
  updateInterval: Duration(seconds: 10),
  distanceFilter: 10.0, // Update if moved 10 meters
);

// Stop tracking
locationService.stopTracking();

// Get current location (one-time)
final position = await locationService.getCurrentLocation();
```

## Integration Example

```dart
class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final webSocketService = WebSocketService();
  final locationService = LocationTrackingService(
    webSocketService: webSocketService,
  );
  
  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }
  
  Future<void> _initializeTracking() async {
    // Connect WebSocket
    await webSocketService.connect(userId: 'user123');
    
    // Listen to location updates from other users
    webSocketService.locationStream.listen((data) {
      // Update map with other user's location
      _updateMapMarker(data);
    });
    
    // Start tracking own location
    await locationService.startTracking(userId: 'user123');
  }
  
  void _updateMapMarker(Map<String, dynamic> locationData) {
    // Update map marker
  }
  
  @override
  void dispose() {
    locationService.stopTracking();
    webSocketService.disconnect();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your UI
    );
  }
}
```
