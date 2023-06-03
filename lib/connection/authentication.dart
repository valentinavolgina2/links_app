import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../widgets/forms/validation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? userEmail;
String? name;
String? imageUrl;

Future<User?> registerWithEmailPassword(String email, String password) async {
  User? user;

  final emailValidationResult = emailValidator(email);
  if (emailValidationResult != null) {
    debugPrint(emailValidationResult);
    throw emailValidationResult;
  }

  final passwordValidationResult = passwordValidator(password);
  if (passwordValidationResult != null) {
    debugPrint(passwordValidationResult);
    throw passwordValidationResult;
  }

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
    if (e.code == 'weak-password' ||
        (e.message != null && e.message!.contains('weak-password'))) {
      debugPrint(
          'The password provided is too weak. Password should be at least 6 characters.');
      throw 'The password provided is too weak.\nPassword should be at least 6 characters.';
    } else if (e.code == 'email-already-in-use' ||
        (e.message != null && e.message!.contains('email-already-in-use'))) {
      debugPrint('An account already exists for that email.');
      throw 'An account already exists for that email.';
    } else if (e.message != null) {
      debugPrint(e.message);
      throw e.message!;
    }
  } catch (e) {
    debugPrint(e.toString());
    throw e.toString();
  }

  return user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  User? user;

  final emailValidationResult = emailValidator(email);
  if (emailValidationResult != null) {
    debugPrint(emailValidationResult);
    throw emailValidationResult;
  }

  final passwordValidationResult = passwordValidator(password);
  if (passwordValidationResult != null) {
    debugPrint(passwordValidationResult);
    throw passwordValidationResult;
  }

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
    } else if (e.code == 'wrong-password' ||
        (e.message != null && e.message!.contains('password is invalid'))) {
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

Future<User?> signInWithFacebook() async {
  User? user;

  // Create a new provider
  FacebookAuthProvider facebookProvider = FacebookAuthProvider();

  facebookProvider.addScope('email');
  facebookProvider.setCustomParameters({
    'display': 'popup',
  });

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(facebookProvider);

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

Future<User?> changePassword(
    {required String currentPassword, required String newPassword}) async {
  final User? user = _auth.currentUser;

  if (user == null) {
    debugPrint('User is null when trying to change password');
    throw 'User is not defined';
  }

  final passwordValidationResult = passwordValidator(newPassword);
  if (passwordValidationResult != null) {
    debugPrint(passwordValidationResult);
    throw passwordValidationResult;
  }

  final cred = EmailAuthProvider.credential(
      email: user.email!, password: currentPassword);

  try {
    await user.reauthenticateWithCredential(cred);

    try {
      await user.updatePassword(newPassword);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password' ||
        (e.message != null && e.message!.contains('weak-password'))) {
        debugPrint(
            'The new password provided is too weak. Password should be at least 6 characters.');
        throw 'The new password provided is too weak.\nPassword should be at least 6 characters.';
      } else {
        throw 'Unknown error occurred during the authetication.';
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' ||
        (e.message != null && e.message!.contains('user-not-found'))) {
      debugPrint('No user found for that email.');
      throw 'No user found for that email.';
    } else if (e.code == 'wrong-password' ||
        (e.message != null && e.message!.contains('password is invalid'))) {
      debugPrint('Wrong current password provided.');
      throw 'Wrong current password provided.';
    } else {
      throw 'Unknown error occurred during the authetication.';
    }
  }

  return user;
}

Future<String> signOut() async {
  if (googleSignIn.clientId != null) {
    await googleSignIn.signOut();
  }

  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;
  name = null;
  imageUrl = null;

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
      name = user.displayName;
      imageUrl = user.photoURL;
    }
  }
}
