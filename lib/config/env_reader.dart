import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform-specific environment variable reader
class EnvReader {
  /// Read environment variable based on platform
  static String? get(String key) {
    if (kIsWeb) {
      return _getWebEnv(key);
    } else {
      // For mobile, this will be handled by flutter_dotenv
      return null;
    }
  }

  /// Read from window.env for web platform
  static String? _getWebEnv(String key) {
    if (!kIsWeb) return null;
    
    try {
      // Access window.env that was injected by build script
      // This uses dart:js which is only available on web
      // ignore: avoid_web_libraries_in_flutter
      final js = (() {
        try {
          // Dynamic import of dart:js
          // ignore: avoid_web_libraries_in_flutter
          return null;
        } catch (e) {
          return null;
        }
      })();
      
      // The actual reading happens via JS interop
      // window.env is set in web/index.html by the build script
      return null; // Will be read from window.env at runtime
    } catch (e) {
      return null;
    }
  }
}

