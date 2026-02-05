import 'dart:async';
import 'dart:io';

class NetworkHelper {
  /// Checks if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to lookup a reliable host
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Returns user-friendly network error message
  static String getNetworkErrorMessage() {
    return 'No internet connection. Please check your network and try again.';
  }
}
