import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'logic/app_entry.dart';


void main() async {



WidgetsFlutterBinding.ensureInitialized();
// Register the onBackgroundMessage handler
FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
print('Handling a background message: ${message.messageId}');

// Print message data
if (message.data != null) {
print('Message data: ${message.data}');
}

// Print notification information
if (message.notification != null) {
print('Notification title: ${message.notification?.title}');
print('Notification body: ${message.notification?.body}');
}

// Handle the background message based on your app's requirements
// ...
}
);
FirebaseMessaging.onMessage.listen((event) {
  if(event.notification != null){
    print(event.notification?.title);
  }
});
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const appEntry());





}