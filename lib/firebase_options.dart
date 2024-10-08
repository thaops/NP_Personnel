// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyAiyzU-BowmQpSVtbQtMUCRPYiGLUCWhW0',
    appId: '1:273987515815:web:5a5eac8f55b7a678b97282',
    messagingSenderId: '273987515815',
    projectId: 'nppersonnel-c2968',
    authDomain: 'nppersonnel-c2968.firebaseapp.com',
    storageBucket: 'nppersonnel-c2968.appspot.com',
    measurementId: 'G-ZNHSPKE1H8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2zfQWHLFPDQSqVlPsNSA0X8dzm6oicHs',
    appId: '1:273987515815:android:bac267246a4a7e11b97282',
    messagingSenderId: '273987515815',
    projectId: 'nppersonnel-c2968',
    storageBucket: 'nppersonnel-c2968.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEhXaKGDMU9lD-soxJvMMlRzZxLudPrvk',
    appId: '1:273987515815:ios:165d4268cec1d35fb97282',
    messagingSenderId: '273987515815',
    projectId: 'nppersonnel-c2968',
    storageBucket: 'nppersonnel-c2968.appspot.com',
    androidClientId: '273987515815-k7jeil1mpnb7ibhefcthunoq9rnc7ott.apps.googleusercontent.com',
    iosClientId: '273987515815-vlilcs1e5dbivi6cfn6scvgkan4vsdql.apps.googleusercontent.com',
    iosBundleId: 'com.example.hocflutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEhXaKGDMU9lD-soxJvMMlRzZxLudPrvk',
    appId: '1:273987515815:ios:165d4268cec1d35fb97282',
    messagingSenderId: '273987515815',
    projectId: 'nppersonnel-c2968',
    storageBucket: 'nppersonnel-c2968.appspot.com',
    androidClientId: '273987515815-k7jeil1mpnb7ibhefcthunoq9rnc7ott.apps.googleusercontent.com',
    iosClientId: '273987515815-vlilcs1e5dbivi6cfn6scvgkan4vsdql.apps.googleusercontent.com',
    iosBundleId: 'com.example.hocflutter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAiyzU-BowmQpSVtbQtMUCRPYiGLUCWhW0',
    appId: '1:273987515815:web:73039b6e620d2842b97282',
    messagingSenderId: '273987515815',
    projectId: 'nppersonnel-c2968',
    authDomain: 'nppersonnel-c2968.firebaseapp.com',
    storageBucket: 'nppersonnel-c2968.appspot.com',
    measurementId: 'G-QJ1J9GB47R',
  );
}
