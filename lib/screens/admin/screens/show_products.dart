import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/loading.dart';

class Showproducts extends StatefulWidget {
  const Showproducts({Key? key}) : super(key: key);

  @override
  State<Showproducts> createState() => _ShowproductsState();
}

class _ShowproductsState extends State<Showproducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("bloods Page"),
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
                  'No Available Data',
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
                  bloodGroup: product['blood_group'],
                  quantity: product['quantity'].toString(),
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
    required this.bloodGroup,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name section with icon
            _buildProductInfoRow(Icons.production_quantity_limits,
                'Blood Donors Name', name, context),
            const SizedBox(height: 8),
            // Price section with icon
            _buildProductInfoRow(
                Icons.bloodtype, 'Quantity', quantity, context),
            const SizedBox(height: 8),
            // quantity section with icon
            _buildProductInfoRow(
                Icons.attach_money, 'Blood Group', bloodGroup, context),
            const SizedBox(height: 8),

            // Delete Button
            Center(
                child: CustomTextButton(
              lable: 'Delete',
              ontap: () => _deleteProduct(context),
              color: Colors.redAccent,
            )),
          ],
        ),
      ),
    );
  }

  // Builds the row with the label, value, and edit button
  Row _buildProductInfoRow(
      IconData icon, String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueGrey),
            const SizedBox(width: 10),
            Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => _showEditDialog(label.toLowerCase(), context),
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
        ),
      ],
    );
  }

  void _showEditDialog(String field, BuildContext context) {
    TextEditingController controller = TextEditingController();

    Get.defaultDialog(
      title: 'Edit $field',
      content: SingleChildScrollView(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            icon: Icon(Icons.edit),
            labelText: 'Enter $field',
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
