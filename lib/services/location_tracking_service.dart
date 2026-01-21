import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'websocket_service.dart';

/// Location Tracking Service
/// Handles GPS location tracking and sends to WebSocket server
class LocationTrackingService {
  static LocationTrackingService? _instance;
  final WebSocketService _webSocketService;
  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;
  String? _currentUserId;
  
  // Location update settings
  Duration _updateInterval = const Duration(seconds: 10); // Update every 10 seconds
  double _distanceFilter = 10.0; // Update if moved 10 meters
  
  LocationTrackingService._(this._webSocketService);
  
  /// Singleton instance
  factory LocationTrackingService({WebSocketService? webSocketService}) {
    _instance ??= LocationTrackingService._(
      webSocketService ?? WebSocketService(),
    );
    return _instance!;
  }
  
  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    final status = await Permission.location.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      // Open app settings
      await openAppSettings();
      return false;
    }
    
    return false;
  }
  
  /// Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  /// Start tracking location
  Future<void> startTracking({
    required String userId,
    Duration? updateInterval,
    double? distanceFilter,
  }) async {
    if (_isTracking) {
      debugPrint('Location tracking already started');
      return;
    }
    
    // Check permissions
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      throw Exception('Location permission not granted');
    }
    
    // Check if location services are enabled
    final isEnabled = await isLocationEnabled();
    if (!isEnabled) {
      throw Exception('Location services are disabled');
    }
    
    _currentUserId = userId;
    if (updateInterval != null) _updateInterval = updateInterval;
    if (distanceFilter != null) _distanceFilter = distanceFilter;
    
    // Get location accuracy settings
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: _distanceFilter.toInt(), // Convert double to int
    );
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _onLocationUpdate(position);
      },
      onError: (error) {
        debugPrint('Location tracking error: $error');
      },
    );
    
    _isTracking = true;
    debugPrint('Location tracking started for user: $userId');
  }
  
  /// Stop tracking location
  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _isTracking = false;
    _currentUserId = null;
    debugPrint('Location tracking stopped');
  }
  
  /// Handle location update
  void _onLocationUpdate(Position position) {
    if (_currentUserId == null) return;
    
    _webSocketService.sendLocation(
      userId: _currentUserId!,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      speed: position.speed,
      heading: position.heading,
    );
  }
  
  /// Get current location (one-time)
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      throw Exception('Location permission not granted');
    }
    
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }
  
  /// Update tracking settings
  void updateSettings({
    Duration? updateInterval,
    double? distanceFilter,
  }) {
    if (updateInterval != null) _updateInterval = updateInterval;
    if (distanceFilter != null) _distanceFilter = distanceFilter;
    
    // Restart tracking if already tracking
    if (_isTracking && _currentUserId != null) {
      stopTracking();
      startTracking(userId: _currentUserId!);
    }
  }
  
  bool get isTracking => _isTracking;
  String? get currentUserId => _currentUserId;
}
