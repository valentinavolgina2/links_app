import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/result_handler.dart';
import '../widgets/forms/validation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? userEmail;
String? name;
String? imageUrl;
bool signedInWithSocial = false;

Future<AuthStatus> registerWithEmailPassword(
    String email, String password) async {
  late AuthStatus status;

  final emailValidationResult = emailValidator(email);
  if (emailValidationResult != null) {
    return AuthStatus.invalidEmail;
  }

  final passwordValidationResult = passwordValidator(password);
  if (passwordValidationResult != null) {
    return AuthStatus.emptyPassword;
  }

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);

      status = AuthStatus.successful;
    } else {
      status = AuthStatus.userNotFound;
    }
  } on FirebaseAuthException catch (e) {
    status = AuthExceptionHandler.handleAuthException(e);
  } catch (e) {
    status = AuthStatus.unknown;
  }

  signedInWithSocial = false;

  return status;
}

Future<AuthStatus> signInWithEmailPassword(
    String email, String password) async {
  late AuthStatus status;

  final emailValidationResult = emailValidator(email);
  if (emailValidationResult != null) {
    return AuthStatus.invalidEmail;
  }

  final passwordValidationResult = passwordValidator(password);
  if (passwordValidationResult != null) {
    return AuthStatus.emptyPassword;
  }

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);

      status = AuthStatus.successful;
    } else {
      status = AuthStatus.userNotFound;
    }
  } on FirebaseAuthException catch (e) {
    status = AuthExceptionHandler.handleAuthException(e);
  }

  signedInWithSocial = false;

  return status;
}

Future<AuthStatus> signInWithGoogle() async {
  late AuthStatus status;

  // The `GoogleAuthProvider` can only be used while running on the web
  // for app: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
  GoogleAuthProvider authProvider = GoogleAuthProvider();

  try {
    final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);

    User? user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);

      signedInWithSocial = true;

      status = AuthStatus.successful;
    } else {
      status = AuthStatus.userNotFound;
    }
  } catch (e) {
    status = AuthStatus.unknown;
  }

  return status;
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

Future<AuthStatus> changePassword(
    {required String currentPassword, required String newPassword}) async {
  final User? user = _auth.currentUser;
  late AuthStatus status;

  if (user == null) {
    return AuthStatus.userNotFound;
  }

  if (passwordValidator(newPassword) != null) {
    return AuthStatus.emptyPassword;
  }

  if (passwordValidator(currentPassword) != null) {
    return AuthStatus.emptyPassword;
  }

  final cred = EmailAuthProvider.credential(
      email: user.email!, password: currentPassword);

  try {
    await user.reauthenticateWithCredential(cred);

    try {
      await user.updatePassword(newPassword);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);

      status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      status = AuthExceptionHandler.handleAuthException(e, newPassword: true);
    }
  } on FirebaseAuthException catch (e) {
    status = AuthExceptionHandler.handleAuthException(e, currentPassword: true);
  }

  return status;
}

Future<AuthStatus> signedInWithPassword({required String email}) async {
  late AuthStatus status;

  await FirebaseAuth.instance.fetchSignInMethodsForEmail(email).then((methods) {
    if (methods.isNotEmpty) {
      status = methods.contains('password')
          ? AuthStatus.successful
          : AuthStatus.passwordResetNotAllowed;
    } else {
      status = AuthStatus.userNotFound;
    }

    return status;
  }).catchError((e) => status = AuthExceptionHandler.handleAuthException(e));

  return status;
}

Future<AuthStatus> resetPassword({required String email}) async {
  late AuthStatus status;

  final emailValidationResult = emailValidator(email);
  if (emailValidationResult != null) {
    status = AuthStatus.invalidEmail;
    return status;
  }

  await _auth
      .sendPasswordResetEmail(
          email: email,
          actionCodeSettings:
              ActionCodeSettings(url: 'https://links-app-d361f.web.app/'))
      .then((value) => status = AuthStatus.successful)
      .catchError((e) => status = AuthExceptionHandler.handleAuthException(e));

  return status;
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

  signedInWithSocial = false;

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
