import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_options.dart';

class DB {
  static const _useEmulator = true;
  // The port we've set the Firebase Database emulator to run on via the
  // `firebase.json` configuration file.
  static const _dbEmulatorPort = 9000;
  // Android device emulators consider localhost of the host machine as 10.0.2.2
  // so let's use that if running on Android.
  static const _dbEmulatorHost = '127.0.0.1';

  static const _authEmulatorPort = 9099;
  static const _authEmulatorHost = 'localhost';

  static const _storageEmulatorPort = 9199;

  static Future<void> connect() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_useEmulator) {
      FirebaseDatabase.instance
          .useDatabaseEmulator(_dbEmulatorHost, _dbEmulatorPort);

      await FirebaseAuth.instance
          .useAuthEmulator(_authEmulatorHost, _authEmulatorPort);

      await FirebaseStorage.instance.useStorageEmulator(_authEmulatorHost, _storageEmulatorPort);
    }
  }

  static void enableLogging(state) {
    final database = FirebaseDatabase.instance;
    database.setLoggingEnabled(state);
  }
}
