import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapp/routes.dart';
// import 'package:mobileapp/screens/profile/profile_screen.dart';
import 'package:mobileapp/screens/splash/prompt_screen.dart';
import 'package:mobileapp/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary_url_gen/transformation/effect/effect.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';

 var cloudinary=Cloudinary.fromStringUrl('cloudinary://478899427726974:gIBOtHgkaKz-xOBNVKdp8MeshR0@dgz06x34f');
Future <void> main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
   
    cloudinary.config.urlConfig.secure = true;
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation',
      theme: theme(),
      home: const PromptScreen(),
      
      routes: routes,
    );
  }
}
