import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flashcard/models/FlashCard.dart';
import 'package:flashcard/screens/FlashCardsScreen.dart';
import 'package:flashcard/screens/SignupScreen.dart';
import 'package:flashcard/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String message = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("FlashCard App")),
      body: SafeArea(
        child: Column(
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
              'Login',
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
                      Text(message),
                      buildButtonLogin(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popAndPushNamed(SignupScreen.routeName);
                        },
                        child: Text("Signup"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
      decoration: const InputDecoration(labelText: "Password"),
      textInputAction: TextInputAction.next,
      autofocus: true,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {},
    );
  }

  TextButton buildButtonLogin() {
    return TextButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            bool isLoginSuccess = await context
                .read<AuthService>()
                .login(emailController.text, passwordController.text);
            if (isLoginSuccess) {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(FlashCardsScreen.routeName);
            } else {
              setState(() {
                message = 'fail';
              });
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
