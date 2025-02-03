import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/snackbar.dart';

class ShowUser extends StatefulWidget {
  const ShowUser({Key? key}) : super(key: key);

  @override
  State<ShowUser> createState() => _ShowUserState();
}

class _ShowUserState extends State<ShowUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  userId: user.id,
                  email: user['email'],
                  name: user['name'],
                  bloodGroup: user['bloodType'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userId;
  final String email;
  final String name;
  final String bloodGroup;
  const UserCard({
    Key? key,
    required this.userId,
    required this.email,
    required this.bloodGroup,
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
            _buildUserInfoRow('User Email:', email, 'email', context),
            _buildUserInfoRow('User Name:', name, 'name', context),
            _buildUserInfoRow('Blood Group:', bloodGroup, 'bloodType', context),
            Center(
              child: CustomTextButton(
                lable: 'Delete',
                ontap: () => _deleteUser(context),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildUserInfoRow(
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
    TextEditingController controller = TextEditingController();

    Get.defaultDialog(
      title: 'Edit $field',
      content: SingleChildScrollView(
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            icon: Icon(Icons.account_circle),
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
                  .collection('users')
                  .doc(userId)
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

  void _deleteUser(BuildContext context) async {
    showDialog(context: context, builder: (_) => const LoadingDialog());

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      Navigator.of(context).pop();
      showbar(
        title: 'Success',
        subtitle: 'User deleted Successful',
        desc: 'User has been deleted successfully.',
        isSuccess: true,
      );
    } catch (e) {
      Navigator.of(context).pop();
     showbar(
        title: 'Failed',
        subtitle: 'UnSuccessful',
        desc: e.toString(),
        isSuccess: true,
      );
    }
  }
}
