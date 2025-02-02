import 'package:flutter/widgets.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/profile/profile.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/prompt_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';


final Map<String, WidgetBuilder> routes = {
  PromptScreen.routeName: (context) => const PromptScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
