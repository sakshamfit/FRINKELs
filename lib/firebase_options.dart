import 'package:firebase_core/firebase_core.dart';

class FirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Default to web/fallback values
    // These should match your Firebase project settings
    return const FirebaseOptions(
      apiKey: 'AIzaSyBGdpuRC6nKUnCQ0QvMzFod9Drayuyk-KM',
      appId: '1:570972122297:android:019ea78d6c82d85bbdbf68',
      messagingSenderId: '570972122297',
      projectId: 'frinkels-4c9cf',
      storageBucket: 'frinkels-4c9cf.firebasestorage.app',
    );
  }
}