class MyFirebaseAuthException implements Exception {
  final String code;
  MyFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      // 🔐 Sign In / Sign Up common errors
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The email is already registered. Please try signing in.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger one.';
      case 'missing-password':
        return 'Please enter your password.';
      case 'missing-email':
        return 'Please enter your email address.';
      case 'invalid-credential':
        return 'The provided credential is invalid or expired.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'internal-error':
        return 'An internal error has occurred. Please try again.';
      case 'invalid-api-key':
        return 'Your Firebase API key is invalid.';
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';
      case 'captcha-check-failed':
        return 'Captcha check failed. Please try again.';
      case 'timeout':
        return 'The request timed out. Please check your connection.';
      case 'quota-exceeded':
        return 'The quota for this operation has been exceeded.';
      case 'provider-already-linked':
        return 'This provider is already linked to this account.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'requires-recent-login':
        return 'Please log in again before performing this operation.';
      case 'invalid-user-token':
        return 'The user\'s credential is no longer valid. Please sign in again.';
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';
      case 'session-expired':
        return 'Your session has expired. Please restart the process.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}
