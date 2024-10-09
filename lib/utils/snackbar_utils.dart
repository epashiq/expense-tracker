import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showMessage(String content) {
    final messengerState = MyApp.scaffoldMessengerKey.currentState;
    
    if (messengerState != null) {
      messengerState.showSnackBar(
        SnackBar(
          content: Text(content),
          duration: const Duration(seconds: 2), 
          backgroundColor: Colors.blue, 
          behavior: SnackBarBehavior.floating, 
        ),
      );
    }
  }
}
