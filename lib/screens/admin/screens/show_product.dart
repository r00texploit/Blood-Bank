import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/loading.dart';

class ShowProduct extends StatefulWidget {
  const ShowProduct({Key? key}) : super(key: key);

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All bloods'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('blood').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No bloods Available',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              );
            }

            final products = snapshot.data!.docs;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  productId: product.id,
                  name: product['donor_name'],
                  quantity: product['quantity'],
                  bloodGroup: product['blood_group'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String quantity;
  final String bloodGroup;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.bloodGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductInfoRow('Donor Name:', name, 'donor_name', context),
            _buildProductInfoRow('Quantity :', quantity, 'quantity', context),
            _buildProductInfoRow(
                'Blood Group:', bloodGroup, 'blood_group', context),
            Center(
              child: CustomTextButton(
                lable: 'Delete',
                ontap: () => _deleteProduct(context),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildProductInfoRow(
      String label, String value, String field, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$label $value',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _showEditDialog(field, context),
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  void _showEditDialog(String field, BuildContext context) {
    final controller = TextEditingController();

    Get.defaultDialog(
      title: 'Edit $field',
      content: SingleChildScrollView(
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            icon: Icon(Icons.edit),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (controller.text.isEmpty) {
              Get.snackbar('Error', '$field cannot be empty',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }
            showDialog(context: context, builder: (_) => const LoadingDialog());

            try {
              await FirebaseFirestore.instance
                  .collection('blood')
                  .doc(productId)
                  .update({field: controller.text});

              Get.back();
              Get.snackbar('Success', '$field updated successfully',
                  backgroundColor: Colors.greenAccent);
            } catch (e) {
              Get.back();
              Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
            }
          },
          child: const Text("Save", style: TextStyle(fontSize: 16)),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  void _deleteProduct(BuildContext context) async {
    showDialog(context: context, builder: (_) => const LoadingDialog());

    try {
      await FirebaseFirestore.instance
          .collection('blood')
          .doc(productId)
          .delete();
      Navigator.of(context).pop();
      Get.snackbar('Success', 'blood deleted successfully',
          backgroundColor: Colors.greenAccent);
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }
}
