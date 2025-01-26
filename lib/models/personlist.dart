// import "package:fire";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobileapp/controllers/person_controller.dart';

class Person {
  String? id;
  String? title, description;
  List<String>? images;
  double? rating;
  bool? isFavourite, isPopular;

  Person({
    required this.id,
    required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.description,
  });

  Person.fromJson(DocumentSnapshot data) {
    id = data.id;
    title = data["title"];
    description = data["description"];
    rating = data["rating"];
    images = data["images"];
    isFavourite = data["isFavourite"];
    isPopular = data["isPopular"];
  }
}

PersonController person = Get.put(PersonController());
// Our demo Persons

// List<Person> demoPersons = [
//   Person(
//     id: 1,
//     images: [
//       "assets/images/a.png",
//     ],
//     title: "Niraj Pandey",
//     description:
//         "Niraj Pandey is a student at University of Texas. His blood is AB+",
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Person(
//     id: 2,
//     images: [
//       "assets/images/b.png",
//     ],
//     title: "Smaran Bhattarai",
//     description:
//         "Smaran Bhattarai is a student at Dallas College. His blood is B-",
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Person(
//     id: 3,
//     images: [
//       "assets/images/c.png",
//     ],
//     title: "Nishant Pandey",
//     description: "Nishant Pandey is a student at UTA. His blood is O+ .",
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Person(
//     id: 4,
//     images: [
//       "assets/images/d.png",
//     ],
//     title: "Kushal Sapkota",
//     description:
//         "Kushal Sapkota is a student at University of Dallas. His blood is A-",
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
//   Person(
//     id: 5,
//     images: [
//       "assets/images/h.png",
//     ],
//     title: "Sajan Poudel",
//     description: description,
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//   ),
// ];

// const String description =
//     "Sajan Poudel is a student from Kentucky Region. His blood is A+";
