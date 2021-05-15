import 'package:flutter/foundation.dart';

void logError(String code, String message) {
  if (message != null) {
    debugPrint('Error: $code\nError Message: $message', wrapWidth: 12);
  } else {
    debugPrint('Error: $code\n', wrapWidth: 12);
  }
}
