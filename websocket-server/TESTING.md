# Testing Guide

คู่มือการทดสอบ WebSocket Server และ Flutter App

## 1. ทดสอบ Server Health Check

### วิธีที่ 1: ใช้ Browser
เปิด browser ไปที่: `http://localhost:3000/health`

ควรเห็น:
```json
{
  "status": "ok",
  "connectedUsers": 0
}
```

### วิธีที่ 2: ใช้ curl
```bash
curl http://localhost:3000/health
```

### วิธีที่ 3: ใช้ Script
```bash
./test-health.sh
```

## 2. ทดสอบ WebSocket Connection (Node.js)

```bash
# Make sure server is running first
npm start

# In another terminal
node test-connection.js
```

ควรเห็น:
```
🔌 Connecting to WebSocket Server: http://localhost:3000
✅ Connected to server
Socket ID: xxxxx
📤 Sent: user-connected
📤 Sent: location-update
📥 Received: location-updated
```

## 3. ทดสอบใน Flutter App

### วิธีที่ 1: เพิ่ม Test Route ใน main.dart

```dart
import 'services/test_websocket.dart';

// ใน MaterialApp
routes: {
  '/test': (context) => const TestWebSocketWidget(),
},
```

### วิธีที่ 2: เปลี่ยน home เป็น TestWidget ชั่วคราว

```dart
home: const TestWebSocketWidget(), // แทน HomePage()
```

### วิธีที่ 3: เพิ่มปุ่มใน HomePage

เพิ่มปุ่มใน HomePage เพื่อ navigate ไปหน้า test

## 4. ขั้นตอนการทดสอบ

### Step 1: Start Server
```bash
cd websocket-server
npm start
```

### Step 2: ทดสอบ Health Check
```bash
./test-health.sh
```

### Step 3: ทดสอบ WebSocket (Node.js)
```bash
node test-connection.js
```

### Step 4: ทดสอบใน Flutter
1. เปิด Flutter app
2. Navigate ไปหน้า Test
3. กดปุ่ม "Connect"
4. ตรวจสอบว่า status เป็น "Connected"
5. กดปุ่ม "Start Tracking" หรือ "Send Test Location"

## 5. Troubleshooting

### Server ไม่ start
- ตรวจสอบว่า port 3000 ว่างอยู่
- ตรวจสอบไฟล์ .env
- ตรวจสอบ database connection

### Flutter ไม่เชื่อมต่อได้
- ตรวจสอบ server URL ใน `WebSocketService`
- สำหรับ iOS Simulator: ใช้ `http://localhost:3000`
- สำหรับ Android Emulator: ใช้ `http://10.0.2.2:3000`
- สำหรับ Physical Device: ใช้ IP address ของคอมพิวเตอร์

### Location Permission ไม่ได้
- ตรวจสอบ `Info.plist` (iOS) และ `AndroidManifest.xml` (Android)
- Request permission ก่อนใช้งาน

## 6. Expected Results

### Server Side:
- Server รันบน port 3000
- Health check return 200 OK
- WebSocket connection successful
- Location updates saved to database

### Flutter Side:
- Connection status แสดง "Connected"
- Location updates ถูกส่งไปยัง server
- รับ location updates จาก users อื่น
- Messages แสดงใน log
