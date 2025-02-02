import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import 'add_admin.dart';
import 'add_blood.dart';
import '../screens/add_user.dart';
import '../screens/show_user.dart';
import 'show_admin.dart';
import 'show_products.dart';

class Management extends StatefulWidget {
  const Management({Key? key}) : super(key: key);

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  final AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: const [
              ManagementCard(
                title: 'Add User',
                icon: Icons.add,
                destination: AddUser(),
              ),
              ManagementCard(
                title: 'Show User',
                icon: Icons.person,
                destination: ShowUser(),
              ),
              ManagementCard(
                title: 'Add Blood ',
                icon: Icons.add_shopping_cart,
                destination: AddProduct(),
              ),
              ManagementCard(
                title: 'Show Products',
                icon: Icons.shopping_cart,
                destination: Showproducts(),
              ),
              ManagementCard(
                title: 'Add Admin',
                icon: Icons.person_add_alt_1,
                destination: AddAdmin(),
              ),
              ManagementCard(
                title: 'Show Admin',
                icon: Icons.admin_panel_settings,
                destination: ShowAdmin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManagementCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget destination;

  const ManagementCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => destination);
      },
      child: Card(
        color: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
