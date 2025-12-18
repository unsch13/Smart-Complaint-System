// This file provides web-specific implementation using dart:js
// It's conditionally imported only on web platform

import 'dart:js' as js;

/// Web-specific implementation for reading window.env
String? readWebEnv(String key) {
  try {
    final windowEnv = js.context['env'];
    if (windowEnv != null) {
      final value = js.context.callMethod('[]', [key]);
      return value?.toString();
    }
  } catch (e) {
    print('Error reading window.env[$key]: $e');
  }
  return null;
}

