import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  showDialogWithLoading({String? message}) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpinKitPouringHourGlassRefined(
                color: Colors.blue,
                size: 50,
              ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void closeDialog() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return showDialogWithLoading();
  }
}
