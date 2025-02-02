import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/blood_controller.dart';
import '../../../models/blood.dart';

class BloodPage extends StatefulWidget {
  const BloodPage({super.key});

  @override
  _BloodPageState createState() => _BloodPageState();
}

class _BloodPageState extends State<BloodPage> {
  final AddBloodController bloodController = Get.put(AddBloodController());

  @override
  void initState() {
    super.initState();
    bloodController.bloodList.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: bloodController.bloodList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Blood blood = Blood.fromJson(
                      snapshot.data!.docs.elementAt(index).data());
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.bloodtype, color: Colors.red),
                      title: Text(blood.donor_name!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Quantity: ${blood.quantity}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Add your onTap code here!
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add blood details page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
