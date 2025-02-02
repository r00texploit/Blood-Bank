import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/blood.dart';

class AddBloodController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController blood_group,
      // cat,
      // price,
      quantity,
      // no,
      // email,
      // password,
      name;
  // group;
  DateTime time = DateTime.now();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bloodList;
  late CollectionReference productsref;
  late Blood products;
  Map<String, dynamic>? pro;
  auth.User? user;

  Stream<QuerySnapshot<Map<String, dynamic>>> getproduct() =>
      FirebaseFirestore.instance
          .collection('blood')
          // .where('blood_group', isEqualTo: products.blood_group)
          .snapshots();

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser;
    super.onInit();
    blood_group = TextEditingController();
    quantity = TextEditingController();
    name = TextEditingController();
    pro = {};

    collectionReference = firebaseFirestore.collection("user");
    productsref = firebaseFirestore.collection("blood");
    bloodList = getproduct();
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Please Add All Field";
    }
    return null;
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

  void addProduct() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      update();
      return;
    } else {
      try {
        // showLoadingDialog();
        await FirebaseFirestore.instance.collection('blood').doc().set({
          "donor_name": name.text,
          "blood_group": blood_group.text,
          "quantity": quantity.text
        });
        Get.back();
        Get.back();
        showSnackbar(
          title: "Donor Added",
          subtitle: "Donor Added",
          desc: "Donor Added",
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

  Future<Map<String, dynamic>?> getProductByBloodGroup(
      String blood_group) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('blood')
          .where('blood_group', isEqualTo: blood_group)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        pro = querySnapshot.docs.first.data() as Map<String, dynamic>;
        log("Product found with blood_group: ${pro!["blood_group"]}");
        update();
        return pro;
      } else {
        log("No product found with blood_group: $blood_group");
        return null;
      }
    } catch (e) {
      log("Error retrieving product: $e");
      return null;
    }
  }

  updateProductQuantity(String blood_group, int i) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood')
          .where('blood_group', isEqualTo: blood_group)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          Map<String, dynamic> productData = value.docs.first.data();
          int currentQuantity = productData['quantity'] ?? 0;
          int newQuantity = currentQuantity + i;
          FirebaseFirestore.instance
              .collection('blood')
              .doc(value.docs.first.id)
              .update({'quantity': newQuantity});
        } else {
          log("No product found with blood_group: $blood_group");
        }
      });
    } catch (e) {
      log("Error updating product quantity: $e");
    }
  }
}
