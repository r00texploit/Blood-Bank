import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapp/controllers/person_controller.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/custom_textfield.dart';

class AddUser extends StatelessWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient for a modern look
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
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
            'Add New Donor',
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
    return GetBuilder<PersonController>(
      init: PersonController(),
      builder: (authController) {
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
              key: authController.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Header
                  Text(
                    'Donor Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3C72),
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  CustomTextField(
                    controller: authController.personNameController,
                    validator: (value) => authController.validateName(value!),
                    lable: 'Donor Name',
                    icon: const Icon(Icons.person_add, color: Colors.blue),
                    input: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Phone Number Field
                  CustomTextField(
                    controller: authController.personBioController,
                    validator: (value) => authController.validateBio(value!),
                    lable: 'Donor Bio',
                    icon: const Icon(Icons.description, color: Colors.green),
                    input: TextInputType.phone,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                    GestureDetector(
                    onTap: () async {
                      final pickedFile = await authController.pickImage();
                      if (pickedFile != null&& pickedFile.path.isNotEmpty && authController.personNameController.text.isNotEmpty) {
                        String downloadUrl = await authController.uploadImageToFirebase(pickedFile,authController.personNameController.text);
                        authController.personImageUrlController.text = downloadUrl;
                      }
                        // Upload image to Firebase
                        
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                      controller: authController.personImageUrlController,
                      validator: (value) =>
                        authController.validateImageUrl(value!),
                      lable: 'Donor Image URL',
                      icon: const Icon(Icons.image_outlined, color: Colors.red),
                      input: TextInputType.text,
                      obscureText: false,
                      ),
                    ),
                    ),
                  const SizedBox(height: 40),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        authController.addPerson();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Donor added successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        backgroundColor: const Color(0xFF1E3C72),
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
