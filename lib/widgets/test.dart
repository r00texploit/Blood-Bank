// import 'package:barcode/model/product_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// Widget build(BuildContext context) {
//   Product product;
//     var _scanBarcode;
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').where("barcode" ,isEqualTo: _scanBarcode).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError)
//             return new Text('Error: ${snapshot.error}');
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
//             default:
//               return new ListView(
//                 padding: EdgeInsets.only(bottom: 80),
//                 children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                   return Padding(
//                     padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//                     child: Card(
//                       child: ListTile(
//                         title: new Text("Title " + document['title']),
//                         subtitle: new Text("Author " + document['author']),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               );
//           }
//         },
//       );
//   }

import 'package:cloud_firestore/cloud_firestore.dart';

dynamic _fetch() async {
  var prod = await FirebaseFirestore.instance
      .collection('products')
      .where("basrcode", isEqualTo: "0964346567")
      .get();
  return prod;
}
