import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/admin/screens/home_admin.dart';
import '../screens/home/home_screen.dart';
import '../screens/sign_in/sign_in_screen.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  late TextEditingController email,
      name,
      password,
      Rpassword,
      repassword,
      bloodType;

  bool ob = false;
  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool obscureTextSignupConfirm = true;
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference collectionReference;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Widget route;
  @override
  void onReady() {
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
    super.onReady();
  }

  var obscureText = true.obs; // RxBool to manage password visibility

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  // void showLoadingDialog() {
  //   showDialog(
  //     context: Get.context!,
  //     barrierDismissible: false,
  //     builder: (_) => const LoadingDialog(),
  //   );
  // }

  void showSnackbar({
    required String title,
    required String subtitle,
    required String desc,
    required bool isSuccess,
  }) {
    Get.snackbar(
      title,
      desc,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    collectionReference = firebaseFirestore.collection("users");
    email = TextEditingController();
    password = TextEditingController();
    Rpassword = TextEditingController();
    repassword = TextEditingController();
    bloodType = TextEditingController();
    name = TextEditingController();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
    super.onInit();
  }

  String? get user_ch => _user.value!.email;

  _initialScreen(User? user) {
    if (user == null) {
      route = SignInScreen();
    } else {
      route = HomeScreen();
    }
  }

  toggleLogin() {
    obscureTextLogin = !obscureTextLogin;
    update();
  }

  toggleSignup() {
    obscureTextSignup = !obscureTextSignup;
    update();
  }

  toggleSignupConfirm() {
    obscureTextSignupConfirm = !obscureTextSignupConfirm;
    update();
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return "please enter your name";
    }
    return null;
  }

  String? validatebloodType(String value) {
    if (value.isEmpty) {
      return "please enter your Phone";
    }
    if (value.length < 10) {
      return "Phone length must be more than 10";
    }
    if (value.startsWith("0") && value.endsWith("0")) {
      return "you can't enter 0 in first";
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty) {
      return "please enter your email";
    }

    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    return null;
  }

  String? validateRePassword(String value) {
    if (value.isEmpty) {
      return "please enter your password";
    }
    if (value.length < 6) {
      return "password length must be more than 6 ";
    }
    if (password.text != value) {
      return "Password not matched ";
    }
    return null;
  }

  changeOb() {
    ob = !ob;
    update(['password']);
  }

  void signOut() async {
    Get.dialog(AlertDialog(
      content: const Text('Are you are sure to log out'),
      actions: [
        TextButton(
            onPressed: () async {
              await auth
                  .signOut()
                  .then((value) => Get.offAll(() => const SignInScreen()));
            },
            child: const Text('yes')),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('back'))
      ],
    ));
  }

  void register() async {
    if (formKey2.currentState!.validate()) {
      try {
        // showLoadingDialog();
        final credential = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        credential.user!.updateDisplayName(name.text);
        await credential.user!.reload();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': name.text,
          'email': email.text,
          'bloodType': bloodType.text,
          'type': "user",
          'uid': credential.user!.uid,
        });
        Get.back();
        email.clear();
        password.clear();
        showSnackbar(
          title: "About User",
          subtitle: "User message",
          desc: "User Created!!",
          isSuccess: true,
        );
      } on FirebaseAuthException catch (e) {
        Get.back();
        showSnackbar(
          title: "About User",
          subtitle: "User message",
          desc: e.toString(),
          isSuccess: false,
        );
      }
    }
  }

  void addAdmin() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      update();
      return;
    } else {
      try {
        // showLoadingDialog();
        FirebaseAuth auth = FirebaseAuth.instance;
        final credential = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        await credential.user!.reload();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(credential.user!.uid)
            .set({
          'type': "admin",
          'name': name.text,
          'email': email.text,
          'uid': credential.user!.uid,
        });
        Get.back();
        showSnackbar(
          title: "Admin Added",
          subtitle: "Admin Added",
          desc: "Admin Added",
          isSuccess: true,
        );
      } catch (e) {
        Get.back();
        showSnackbar(
          title: "Error",
          subtitle: "Error",
          desc: e.toString(),
          isSuccess: false,
        );
      }
    }
  }

  void addUser() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      update();
      return;
    } else {
      // showLoadingDialog();
      FirebaseAuth auth = FirebaseAuth.instance;
      final credential = await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await credential.user!.reload();
      var re = <String, dynamic>{
        'uid': credential.user!.uid,
        "type": "user",
        "email": email.text,
        "name": name.text,
        "bloodType": bloodType.text
      };
      collectionReference.doc().set(re).whenComplete(() {
        Get.back();
        showSnackbar(
          title: "user Added",
          subtitle: "user Added",
          desc: "user Added",
          isSuccess: true,
        );
        bloodType.clear();
      }).catchError((error) {
        Get.back();
        showSnackbar(
          title: "Error",
          subtitle: "Error",
          desc: error.toString(),
          isSuccess: false,
        );
      });
    }
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        // showLoadingDialog();
        final credential = await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);

        log("uid:${credential.user!.uid}");
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.text)
            .limit(1)
            .get();

        if (userDoc.docs.isNotEmpty) {
          String userType = userDoc.docs.first['type'];

          if (userType == "admin") {
            Get.offAll(() => HomeAdmin());
          } else {
            Get.offAll(() => HomeScreen());
          }
        } else {
          Get.back();
          showSnackbar(
            title: "About Login",
            subtitle: "Login message",
            desc: 'User not found',
            isSuccess: false,
          );
        }
      } on FirebaseAuthException catch (e) {
        Get.back();
        String errorMessage = '';

        switch (e.code) {
          case 'weak-password':
            errorMessage = 'weak password';
            break;
          case 'email-already-in-use':
            errorMessage = 'email-already-in-use';
            break;
          case 'user-not-found':
            errorMessage = 'user-not-found';
            break;
          case 'wrong-password':
            errorMessage = 'wrong-password';
            break;
          default:
            errorMessage = e.toString();
        }

        showSnackbar(
          title: "About Login",
          subtitle: "Login message",
          desc: errorMessage,
          isSuccess: false,
        );
      }
    }
  }
}
