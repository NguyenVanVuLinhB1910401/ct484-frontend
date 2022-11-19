import 'package:flashcard/screens/FlashCardsScreen.dart';
import 'package:flashcard/screens/LoginScreen.dart';
import 'package:flashcard/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const routeName = '/signup';
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordReController = TextEditingController();

  bool isShowPassword = false;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Transform.rotate(
            angle: -math.pi / 4,
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/4560/4560899.png",
              height: 150,
              width: 150,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Signup',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: ListView(
                  children: [
                    buildEmailField(),
                    buildPasswordField(),
                    buildRePasswordField(),
                    Text(message),
                    buildButtonSignup(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popAndPushNamed(LoginScreen.routeName);
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(labelText: "Email"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isShowPassword = !isShowPassword;
            });
          },
          icon: Icon(isShowPassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      obscureText: !isShowPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextFormField buildRePasswordField() {
    return TextFormField(
      controller: passwordReController,
      decoration: InputDecoration(
        labelText: "Re-Password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isShowPassword = !isShowPassword;
            });
          },
          icon: Icon(isShowPassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      obscureText: !isShowPassword,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextButton buildButtonSignup() {
    return TextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (passwordController.text == passwordReController.text) {
            bool isSignup = await context
                .read<AuthService>()
                .signup(emailController.text, passwordController.text);
            if (isSignup) {
              setState(() {
                message = 'Đăng ký thành công';
              });
              emailController.clear();
              passwordController.clear();
              passwordReController.clear();
            } else {
              setState(() {
                message = 'Đăng ký thất bại';
              });
            }
          } else {
            setState(() {
              message = 'Mật khẩu không trùng khớp';
            });
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(
        "Signup",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
