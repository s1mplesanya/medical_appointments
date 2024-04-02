import 'package:flutter/material.dart';
import 'package:medical_appointments/application/ui/themes/app_colors.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.down,
        backgroundColor: AppColors.black,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 0,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
