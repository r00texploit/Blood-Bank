// import 'package:flutter/material.dart';
//
// class CardWidget extends StatelessWidget {
//    const CardWidget(
//       {Key? key,  required this.title, required this.icon, required this.nav})
//       : super(key: key);
//   final String title;
//   final dynamic icon;
//   final dynamic nav;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.transparent,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15)
//       ),
//
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//          color: Colors.black.withOpacity(.5)
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//
//           children:  [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("حجز باسم:   ${logic.reservaiton[index].name}", style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('عدد المقاعد:  ${logic.reservaiton[index].passNumber}', style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('مسار الرحلة:  ${logic.reservaiton[index].from}-${logic.reservaiton[index].to}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('الزمن:  ${logic.reservaiton[index].time}', style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
