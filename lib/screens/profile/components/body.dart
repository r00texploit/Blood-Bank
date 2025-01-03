import 'package:flutter/material.dart';

import 'profile_pic.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: const [
          ProfilePic(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
