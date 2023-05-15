import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? userEmail;
String? name;
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
      debugPrint('The password provided is too weak.');
      throw 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      debugPrint('An account already exists for that email.');
      throw 'An account already exists for that email.';
    }
  } catch (e) {
    debugPrint(e.toString());
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
      debugPrint('No user found for that email.');
      throw 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      debugPrint('Wrong password provided.');
      throw 'Wrong password provided.';
    } else {
      throw 'Unknown error occurred during the authetication.';
    }
  }

  return user;
}

Future<User?> signInWithGoogle() async {
  User? user;

  // The `GoogleAuthProvider` can only be used while running on the web
  // for app: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);

    user = userCredential.user;
  } catch (e) {
    debugPrint(e.toString());
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
  }

  return user;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;
  name = null;
  imageUrl = null;

  return 'User signed out';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  debugPrint("User signed out of Google account");
}

Future getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;

  final User? user = _auth.currentUser;

  if (authSignedIn == true) {
    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
      name = user.displayName;
      imageUrl = user.photoURL;
    }
  }
}
