import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/loading.dart';

class ShowAdmin extends StatelessWidget {
  const ShowAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('type', isEqualTo: "admin")
              .snapshots(),
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
                  'No Admins Found',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              );
            }

            final admins = snapshot.data!.docs;

            return ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                final admin = admins[index];

                return AdminCard(
                  adminId: admin.id,
                  email: admin['email'],
                  name: admin['name'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final String adminId;
  final String email;
  final String name;

  const AdminCard({
    Key? key,
    required this.adminId,
    required this.email,
    required this.name,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Email: $email",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, adminId, 'email'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Name: $name",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, adminId, 'email'),
                ),
              ],
            ),
            Center(
              child: CustomTextButton(
                lable: 'Delete',
                ontap: () => _deleteAdmin(context, adminId),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAdmin(BuildContext context, String adminId) async {
    showDialog(
      context: context,
      builder: (_) => const LoadingDialog(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(adminId)
          .delete();
      Navigator.of(context).pop();
      Get.snackbar(
        'Success',
        'Admin deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showEditDialog(BuildContext context, String adminId, String field) {
    final controller = TextEditingController();

    Get.defaultDialog(
      title: 'Edit $field',
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: const Icon(Icons.edit),
          hintText: 'Enter new $field',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final newValue = controller.text.trim();
            if (newValue.isEmpty) {
              Get.snackbar('Error', '$field cannot be empty',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }
            showDialog(
              context: context,
              builder: (_) => LoadingDialog(),
            );

            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(adminId)
                  .update({field: newValue});

              Navigator.of(context).pop(); // Close LoadingDialog
              Get.back(); // Close DefaultDialog
              Get.snackbar(
                'Success',
                '$field updated successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } catch (e) {
              Navigator.of(context).pop();
              Get.snackbar(
                'Error',
                e.toString(),
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
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
}
