import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? userEmail;
String? imageUrl;

Future<User?> registerWithEmailPassword(String email, String password) async {
  User? user;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      throw 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      print('An account already exists for that email.');
      throw 'An account already exists for that email.';
    }
  } catch (e) {
    print(e);
    throw e.toString();
  }

  return user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  User? user;
  
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' ||
        (e.message != null && e.message!.contains('user-not-found'))) {
      print('No user found for that email.');
      throw 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
      throw 'Wrong password provided.';
    } else {
      throw 'Unknown error occurred during the authetication.';
    }
  }

  return user;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;

  return 'User signed out';
}

Future getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;

  final User? user = _auth.currentUser;

  if (authSignedIn == true) {
    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  }
}
