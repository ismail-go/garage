import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBY-7x3QUhh4CZWZWT8QrzaXzXJTTznDz4',
    appId: '1:137553104399:web:0c850dd25f4d3c8ea7dd7a',
    messagingSenderId: '137553104399',
    projectId: 'garage-7965c',
    authDomain: 'garage-7965c.firebaseapp.com',
    storageBucket: 'garage-7965c.firebasestorage.app',
    measurementId: 'G-FEXD728DW8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACOQLAoo-ehfk7ehSC0GGCBSWB9_BNcXc',
    appId: '1:137553104399:android:70226cec950d39baa7dd7a',
    messagingSenderId: '137553104399',
    projectId: 'garage-7965c',
    storageBucket: 'garage-7965c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_NdGX6zkRxU5_yBUEccTT1s8hP0Y3RVE',
    appId: '1:137553104399:ios:92da8554fa7562ada7dd7a',
    messagingSenderId: '137553104399',
    projectId: 'garage-7965c',
    storageBucket: 'garage-7965c.firebasestorage.app',
    iosBundleId: 'com.ismailgozen.garage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_NdGX6zkRxU5_yBUEccTT1s8hP0Y3RVE',
    appId: '1:137553104399:ios:fda87008b2a27781a7dd7a',
    messagingSenderId: '137553104399',
    projectId: 'garage-7965c',
    storageBucket: 'garage-7965c.firebasestorage.app',
    iosBundleId: 'com.ismailgozen.garage',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBY-7x3QUhh4CZWZWT8QrzaXzXJTTznDz4',
    appId: '1:137553104399:web:938cf335c2edf5b4a7dd7a',
    messagingSenderId: '137553104399',
    projectId: 'garage-7965c',
    authDomain: 'garage-7965c.firebaseapp.com',
    storageBucket: 'garage-7965c.firebasestorage.app',
    measurementId: 'G-M3EXNRVKSH',
  );
} 