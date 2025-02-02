// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:hotel_book/screens/Bills_page.dart';
// import 'package:hotel_book/screens/change_password.dart';
// import 'package:hotel_book/screens/my_resrvation.dart';
// import 'package:hotel_book/screens/my_services.dart';

// import '../controller/auth_controller.dart';

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AuthController controller = Get.find();
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           _createHeader(),
//           _createDrawerItem(
//             icon: Icons.accessibility,
//             text: 'My Resrvation',
//             onTap: () {
//               Get.to(() => const MyResrvation());
//             },
//           ),
//           _createDrawerItem(
//             icon: Icons.monetization_on,
//             text: 'My Bills',
//             onTap: () {
//               Get.to(() => const MyBills());
//             },
//           ),
//           _createDrawerItem(
//             icon: Icons.home_repair_service,
//             text: 'My Services',
//             onTap: () {
//               Get.to(() => const MyServices());
//             },
//           ),
//           const Divider(),
//           _createDrawerItem(
//               icon: Icons.help,
//               text: 'Change Password',
//               onTap: () {
//                 Get.to(() => const ChangePassword());
//               }),
//           _createDrawerItem(
//               icon: Icons.help, text: 'About Application', onTap: () {}),
//           const Divider(),
//           _createDrawerItem(
//               icon: Icons.logout,
//               text: 'SignOut',
//               onTap: () {
//                 controller.signOut();
//               }),
//         ],
//       ),
//     );
//   }

//   Widget _createHeader() {
//     return DrawerHeader(
//         decoration: BoxDecoration(
//           color: Colors.yellow[900],
//         ),
//         margin: EdgeInsets.zero,
//         padding: EdgeInsets.zero,
//         child: Column(mainAxisAlignment: MainAxisAlignment.start,
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: const <Widget>[
//               Image(
//                 image: AssetImage('images/logo.png'),
//                 height: 80,
//                 width: 80,
//               ),
//               Text("Hotel Book",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.w500)),
//             ]));
//   }

//   Widget _createDrawerItem(
//       {required IconData icon,
//       required String text,
//       required GestureTapCallback onTap}) {
//     return ListTile(
//       title: Row(
//         children: <Widget>[
//           Icon(icon),
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(text),
//           )
//         ],
//       ),
//       onTap: onTap,
//     );
//   }
// }
