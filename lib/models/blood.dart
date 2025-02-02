import 'package:cloud_firestore/cloud_firestore.dart';

class Blood {
  String? id;
  String? donor_name;
  String? blood_group;
  int? quantity;

  Blood({
    this.id,
    required this.donor_name,
    required this.blood_group,
    required this.quantity,
  });

  Blood.fromMap(DocumentSnapshot data) {
    donor_name = data["donor_name"];
    blood_group = data["blood_group"];
    quantity = data["quantity"];
  }
  Blood.fromJson(Map<String, dynamic> data) {
    donor_name = data["donor_name"];
    blood_group = data["blood_group"];
    quantity = data["quantity"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donor_name': donor_name,
      'blood_group': blood_group,
      'quantity': quantity,
    };
  }
}