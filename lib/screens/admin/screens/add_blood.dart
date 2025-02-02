import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/blood_controller.dart';
import '../../../widgets/custom_textfield.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background for consistency with modern UI
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Expanded(
                child: _buildForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            'Add New Blood Vasles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return GetBuilder<AddBloodController>(
      init: AddBloodController(),
      builder: (bloodController) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: bloodController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Header
                  Text(
                    'Blood Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6A11CB),
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Product Name Field
                  CustomTextField(
                    controller: bloodController.name,
                    validator: (value) =>
                        bloodController.validateAddress(value!),
                    lable: 'Donor Name',
                    icon: const Icon(Icons.person,
                        color: Colors.blue),
                    input: TextInputType.text,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Price Field
                  CustomTextField(
                    controller: bloodController.blood_group,
                    validator: (value) =>
                        bloodController.validateAddress(value!),
                    lable: 'Blood Group',
                    icon: const Icon(Icons.bloodtype_outlined,
                        color: Colors.green),
                    input: TextInputType.number,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Price Field
                  CustomTextField(
                    controller: bloodController.quantity,
                    validator: (value) =>
                        bloodController.validateAddress(value!),
                    lable: 'Quantity',
                    icon: const Icon(Icons.numbers,
                        color: Colors.green),
                    input: TextInputType.number,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        bloodController.addProduct();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Blood added successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        backgroundColor: const Color(0xFF6A11CB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
