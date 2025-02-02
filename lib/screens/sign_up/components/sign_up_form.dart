import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapp/components/custom_surfix_icon.dart';
import 'package:mobileapp/components/default_button.dart';
import 'package:mobileapp/components/form_error.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  static const String id = 'RegisterScreen';
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // final _auth = FirebaseAuth.instance;
  // final _formKey = GlobalKey<FormState>();
  var auth = Get.put(AuthController());


  // String? email;
  // String? password;
  // String? conform_password;
  // String? fullName;
  String errorMessage = '';
  bool remember = false;
  final bool _spinner = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: auth.formKey2,
      child: Column(
        children: [
          buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(28)),
          buildBloodGroup(),
          SizedBox(height: getProportionateScreenHeight(28)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(28)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(28)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Sign Up",
            press: () async {

                auth.register();
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: auth.email,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => auth.email.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        auth.email.text = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/mail.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: auth.password,
      obscureText: true,
      onSaved: (newValue) => auth.password.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        auth.password.text = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/lock.svg"),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      controller: auth.repassword,
      obscureText: true,
      onSaved: (newValue) => auth.repassword.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && auth.password.text == auth.repassword.text) {
          removeError(error: kMatchPassError);
        }
        auth.repassword.text = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((auth.password.text != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/lock.svg"),
      ),
    );
  }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      controller: auth.name,
      onSaved: (newValue) => auth.name.text = newValue!,
      decoration: const InputDecoration(
        labelText: "Full Name",
        hintText: "Enter your full name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildBloodGroup() {
    return TextFormField(
      onSaved: (newValue) => auth.bloodType.text = newValue!,
      decoration: const InputDecoration(
        labelText: "Blood Group",
        hintText: "Enter your blood group type",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
