class MyFirebaseServiceException implements Exception {
  const MyFirebaseServiceException(this.code, {this.plugin});
  final String code;
  final String? plugin;

  String get message {
    switch (code) {
      // 🔹 General / Network Errors
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'timeout':
        return 'The request timed out. Please try again.';
      case 'unavailable':
        return 'The service is currently unavailable. Try again later.';
      case 'internal':
      case 'internal-error':
        return 'Internal server error. Please try again later.';
      case 'unknown':
        return 'An unknown error occurred. Please try again.';
      // 🔹 Firestore Errors
      case 'permission-denied':
        return 'Permission denied. You do not have access to this resource.';
      case 'unauthenticated':
        return 'User is not authenticated.';
      case 'not-found':
        return 'The requested document or collection was not found.';
      case 'already-exists':
        return 'The document you are trying to create already exists.';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'invalid-argument':
        return 'Invalid argument provided to the operation.';
      case 'resource-exhausted':
        return 'Quota exceeded or resource exhausted.';
      case 'failed-precondition':
        return 'Operation cannot be performed in the current state.';
      case 'aborted':
        return 'Operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Operation was attempted past valid range.';
      case 'data-loss':
        return 'Unrecoverable data loss occurred.';
      case 'deadline-exceeded':
        return 'Deadline exceeded for the operation.';

      // 🔹 Storage Errors
      case 'unauthorized':
        return 'Unauthorized access. You do not have permission to access this file.';
      case 'object-not-found':
        return 'The requested file was not found in storage.';
      case 'bucket-not-found':
        return 'The specified storage bucket does not exist.';
      case 'quota-exceeded':
        return 'Storage quota exceeded. Please try later.';
      case 'retry-limit-exceeded':
        return 'Retry limit exceeded. Please try again later.';
      // case 'cancelled':
      //   return 'The storage operation was cancelled.';
      case 'invalid-checksum':
        return 'The file checksum is invalid.';
      case 'download-size-exceeded':
        return 'The download size exceeded the allowed limit.';
      case 'project-not-found':
        return 'The specified Firebase project does not exist.';
      case "account-exists-with-different-credential":
        return "This email is already registered using another sign-in method (e.g. Google or Email).";

      // 🔹 Fallback
      default:
        return 'An unknown error occurred in ${plugin ?? 'Firebase'}: $code';
    }
  }
}
