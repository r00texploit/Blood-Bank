import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/personlist.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PersonController extends GetxController {
  // Text Editing Controllers
  final personNameController = TextEditingController();
  final personBioController = TextEditingController();
  final personImageUrlController = TextEditingController();
  final personRatingController = TextEditingController();
  final isPersonFavoriteController = TextEditingController();
  final isPersonPopularController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Reactive list of persons
  final persons = <Person>[].obs;

  // Firestore instance
  final _firestore = FirebaseFirestore.instance;

  // Collection reference
  final _personCollection = FirebaseFirestore.instance.collection('person');

  // Stream of persons
  Stream<List<Person>> getPersonStream() {
    return _personCollection.snapshots().map(
        (query) => query.docs.map((item) => Person.fromJson(item)).toList());
  }

  // Validators
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? validateBio(String value) {
    if (value.isEmpty) {
      return 'Bio cannot be empty';
    }
    return null;
  }

  String? validateImageUrl(String value) {
    if (value.isEmpty) {
      return 'Image URL cannot be empty';
    }
    return null;
  }

  String? validateRating(String value) {
    final rating = double.tryParse(value);
    if (rating == null || rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }
    return null;
  }

  String? validateIsFavorite(String value) {
    if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
      return 'Value must be true or false';
    }
    return null;
  }

  String? validateIsPopular(String value) {
    if (value.toLowerCase() != 'true' && value.toLowerCase() != 'false') {
      return 'Value must be true or false';
    }
    return null;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPersonStream().listen((data) {
      persons.assignAll(data);
    }, onError: (error) {
      // Handle error
      print('Error fetching persons: $error');
      Get.snackbar('Error', 'Failed to fetch persons');
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Listen to the stream and update the reactive list
    getPersonStream().listen((data) {
      persons.assignAll(data);
    }, onError: (error) {
      // Handle error
      print('Error fetching persons: $error');
      Get.snackbar('Error', 'Failed to fetch persons');
    });
  }

  @override
  void onClose() {
    // Dispose of controllers
    personNameController.dispose();
    personBioController.dispose();
    personImageUrlController.dispose();
    personRatingController.dispose();
    isPersonFavoriteController.dispose();
    isPersonPopularController.dispose();
    super.onClose();
  }

  // Create (Add) a new person
  Future<void> addPerson() async {
    try {
      // Create a new person object
      final newPerson = Person(
        title: personNameController.text,
        description: personBioController.text,
        images: personImageUrlController.text,
        rating: double.tryParse(personRatingController.text) ?? 0.0,
        isFavourite: isPersonFavoriteController.text.toLowerCase() == 'true',
        isPopular: isPersonPopularController.text.toLowerCase() == 'true',
        id: '',
      );

      // Add the person to Firestore
      await _personCollection.add(newPerson.toJson());

      // Clear the text fields
      personNameController.clear();
      personBioController.clear();
      personImageUrlController.clear();
      personRatingController.clear();
      isPersonFavoriteController.clear();
      isPersonPopularController.clear();

      Get.snackbar('Success', 'Person added successfully');
    } catch (e) {
      print('Error adding person: $e');
      Get.snackbar('Error', 'Failed to add person');
    }
  }

  // Read (Get) a person by ID
  Future<Person?> getPersonById(String personId) async {
    try {
      final docSnapshot = await _personCollection.doc(personId).get();
      if (docSnapshot.exists) {
        return Person.fromJson(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting person: $e');
      Get.snackbar('Error', 'Failed to get person');
      return null;
    }
  }

  // Update an existing person
  Future<void> updatePerson(String personId) async {
    try {
      // Create a new person object
      final updatedPerson = Person(
        title: personNameController.text,
        description: personBioController.text,
        images: personImageUrlController.text,
        rating: double.tryParse(personRatingController.text) ?? 0.0,
        isFavourite: isPersonFavoriteController.text.toLowerCase() == 'true',
        isPopular: isPersonPopularController.text.toLowerCase() == 'true',
        id: '',
      );
      await _personCollection.doc(personId).update(updatedPerson.toJson());

      // Clear the text fields
      personNameController.clear();
      personBioController.clear();
      personImageUrlController.clear();
      personRatingController.clear();
      isPersonFavoriteController.clear();
      isPersonPopularController.clear();

      Get.snackbar('Success', 'Person updated successfully');
    } catch (e) {
      print('Error updating person: $e');
      Get.snackbar('Error', 'Failed to update person');
    }
  }

  // Delete a person
  Future<void> deletePerson(String personId) async {
    try {
      await _personCollection.doc(personId).delete();
      Get.snackbar('Success', 'Person deleted successfully');
    } catch (e) {
      print('Error deleting person: $e');
      Get.snackbar('Error', 'Failed to delete person');
    }
  }

pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    personImageUrlController.text = pickedFile.path;
  } else {
    Get.snackbar('Error', 'No image selected');
  }
}

  Future<String> uploadImageToFirebase(XFile pickedFile,String personName) async {
    try {
      // Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref().child('person_images/$personName.jpg');
      
      // Upload the file to Firebase Storage
      await storageRef.putFile(File(pickedFile.path));
      
      // Get the download URL of the uploaded file
      final downloadUrl = await storageRef.getDownloadURL();
      
      // Update the personImageUrlController with the download URL
      personImageUrlController.text = downloadUrl;
      Get.snackbar('Success', 'Image uploaded successfully');
      return downloadUrl;
      
  
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image');
      return '';
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mobileapp/models/personlist.dart';
//
// class PersonController extends GetxController {
//   TextEditingController?  title, description,images,rating,isFavourite, isPopular;
//   Stream<List<Person>> getPersons() => FirebaseFirestore.instance
//       .collection('person')
//       .snapshots()
//       .map((query) => query.docs.map((item) => Person.fromJson(item)).toList());
//   List<Person>? persons;
//
//   PersonController() {
//     getPersons().listen((data) {
//       persons = data;
//     });
//   }
//
//   @override
//   void onInit(){
//     super.onInit();
//
//
//   }
//
//   addPerson(){
//
//   }
// }
