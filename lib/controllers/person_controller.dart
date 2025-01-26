import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileapp/models/personlist.dart';

class PersonController extends GetxController {
  Stream<List<Person>> getpersons() => FirebaseFirestore.instance
      .collection('person')
      .snapshots()
      .map((query) => query.docs.map((item) => Person.fromJson(item)).toList());
  List<Person>? persons;

  PersonController() {
    getpersons().listen((data) {
      persons = data;
    });
  }
}
