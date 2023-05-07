import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase_options.dart';

class DB {
  static const _useDatabaseEmulator = true;
  // The port we've set the Firebase Database emulator to run on via the
  // `firebase.json` configuration file.
  static const _emulatorPort = 9000;
  // Android device emulators consider localhost of the host machine as 10.0.2.2
  // so let's use that if running on Android.
  static const _emulatorHost = '127.0.0.1';

  static Future<void> connect() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_useDatabaseEmulator) {
      FirebaseDatabase.instance
          .useDatabaseEmulator(_emulatorHost, _emulatorPort);
    }
  }

  static void enableLogging(state) {
    final database = FirebaseDatabase.instance;
    database.setLoggingEnabled(state);
  }
}
