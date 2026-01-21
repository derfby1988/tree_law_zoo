import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

/// WebSocket Service for Real-time Communication
/// Self-hosted WebSocket Server Connection
class WebSocketService {
  static WebSocketService? _instance;
  IO.Socket? _socket;
  final String _serverUrl;
  bool _isConnected = false;
  
  // Stream Controllers
  final _connectionController = StreamController<bool>.broadcast();
  final _locationController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  
  // Getters
  bool get isConnected => _isConnected;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;
  Stream<String> get errorStream => _errorController.stream;
  
  WebSocketService._(this._serverUrl);
  
  /// Singleton instance
  factory WebSocketService({String? serverUrl}) {
    _instance ??= WebSocketService._(
      serverUrl ?? 'http://localhost:3000', // Default server URL
    );
    return _instance!;
  }
  
  /// Connect to WebSocket Server
  Future<void> connect({String? userId, String? authToken}) async {
    if (_isConnected) {
      debugPrint('WebSocket already connected');
      return;
    }
    
    try {
      _socket = IO.io(
        _serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setAuth({'userId': userId, 'token': authToken})
            .build(),
      );
      
      // Connection Events
      _socket!.onConnect((_) {
        debugPrint('WebSocket connected');
        _isConnected = true;
        _connectionController.add(true);
        
        // Send user info after connection
        if (userId != null) {
          _socket!.emit('user-connected', {'userId': userId});
        }
      });
      
      _socket!.onDisconnect((_) {
        debugPrint('WebSocket disconnected');
        _isConnected = false;
        _connectionController.add(false);
      });
      
      _socket!.onConnectError((error) {
        debugPrint('WebSocket connection error: $error');
        _errorController.add('Connection error: $error');
      });
      
      // Location Events
      _socket!.on('location-updated', (data) {
        debugPrint('Location updated: $data');
        _locationController.add(Map<String, dynamic>.from(data));
      });
      
      _socket!.on('error', (error) {
        debugPrint('WebSocket error: $error');
        _errorController.add('Error: $error');
      });
      
    } catch (e) {
      debugPrint('Failed to connect WebSocket: $e');
      _errorController.add('Failed to connect: $e');
    }
  }
  
  /// Send location update to server
  void sendLocation({
    required String userId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? speed,
    double? heading,
  }) {
    if (!_isConnected || _socket == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    final locationData = {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
    };
    
    _socket!.emit('location-update', locationData);
  }
  
  /// Subscribe to specific user's location
  void subscribeToUser(String userId) {
    if (!_isConnected || _socket == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    _socket!.emit('subscribe-user', {'userId': userId});
  }
  
  /// Unsubscribe from user's location
  void unsubscribeFromUser(String userId) {
    if (!_isConnected || _socket == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    _socket!.emit('unsubscribe-user', {'userId': userId});
  }
  
  /// Join a room (e.g., for group tracking)
  void joinRoom(String roomId) {
    if (!_isConnected || _socket == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    _socket!.emit('join-room', {'roomId': roomId});
  }
  
  /// Leave a room
  void leaveRoom(String roomId) {
    if (!_isConnected || _socket == null) {
      debugPrint('WebSocket not connected');
      return;
    }
    
    _socket!.emit('leave-room', {'roomId': roomId});
  }
  
  /// Disconnect from server
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      _connectionController.add(false);
    }
  }
  
  /// Dispose resources
  void dispose() {
    disconnect();
    _connectionController.close();
    _locationController.close();
    _errorController.close();
  }
}
