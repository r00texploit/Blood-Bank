import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showbar({
  required String title, 
  required String subtitle, 
  required String desc, 
  required bool isSuccess, 
  Duration duration = const Duration(seconds: 2),
}) {
  Get.snackbar(
    title, 
    subtitle,
    backgroundColor: isSuccess ? Colors.greenAccent : Colors.redAccent,
    snackPosition: SnackPosition.BOTTOM,
    messageText: Text(
      desc, 
      style: const TextStyle(color: Colors.white),
    ),
    duration: duration,
  );
}
