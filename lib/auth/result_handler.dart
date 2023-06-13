import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  wrongCurrentPassword,
  emailAlreadyExists,
  userNotFound,
  invalidEmail,
  weakPassword,
  weakNewPassword,
  emptyPassword,
  passwordResetNotAllowed,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(
    FirebaseAuthException e, {
      bool currentPassword = false,
      bool newPassword = false
    }) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = currentPassword ? AuthStatus.wrongCurrentPassword : AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = newPassword ? AuthStatus.weakNewPassword : AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      default:
        status = AuthStatus.unknown;
    }

    if (e.message == null) {
      status = AuthStatus.unknown;
    } else if (e.message!.contains('invalid-email')) {
      status = AuthStatus.invalidEmail;
    } else if (e.message!.contains('wrong-password') || e.message!.contains('password is invalid')) {
      status = currentPassword ? AuthStatus.wrongCurrentPassword : AuthStatus.wrongPassword;
    } else if (e.message!.contains('weak-password') || e.message!.contains('Password should be at least 6 characters')) {
      status = newPassword ? AuthStatus.weakNewPassword : AuthStatus.weakPassword;
    } else if (e.message!.contains('email-already-in-use') || e.message!.contains('email address is already in use')) {
      status = AuthStatus.emailAlreadyExists;
    } else if (e.message!.contains('user-not-found') || e.message!.contains('no user record')) {
      status = AuthStatus.userNotFound;
    } else {
      status = AuthStatus.unknown;
    }

    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.weakNewPassword:
        errorMessage = "Your new password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthStatus.wrongCurrentPassword:
        errorMessage = "Your current password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = "No user found for this email address.";
        break;
      case AuthStatus.passwordResetNotAllowed:
        errorMessage = "Password reset is not allowed for this email address.";
        break;
      case AuthStatus.emptyPassword:
        errorMessage = "Enter the password.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
