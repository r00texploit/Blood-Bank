import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/blood_controller.dart';

class GetProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const GetProductDetails(this.product, {Key? key}) : super(key: key);

  @override
  State<GetProductDetails> createState() => _GetProductDetailsState();
}

class _GetProductDetailsState extends State<GetProductDetails> {
  final AddBloodController addProductsController =
      Get.put(AddBloodController());
  // final CartController cartController = Get.put(CartController());

  bool loading = false;

  @override
  void initState() {
    super.initState();
    log("GetProductDetails => ${widget.product}");
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Details'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductCard(product),
                    const SizedBox(height: 20),
                    // _buildActions(context, product),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      color: const Color.fromRGBO(19, 26, 44, 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['donor_name'] ?? 'Unknown Person',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Blood Group: \$${product['blood_group'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 5),
            Text(
              'Quantity: \$${product['quantity'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
