import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_filed.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController email;
  late TextEditingController password;
  late FocusNode focusNodeemail;
  late FocusNode focusNodpass;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    focusNodeemail = FocusNode();
    focusNodpass = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    focusNodeemail.dispose();
    focusNodpass.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: kToolbarHeight),
              Text(
                "Welcome back",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                "Sign in to countinue",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              //email
              CustomTextFiled(
                focusNode: focusNodeemail,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(focusNodpass);
                },
                controller: email,
                labeltext: "E-mail",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              //password
              const SizedBox(height: 16),
              CustomTextFiled(
                focusNode: focusNodpass,
                controller: password,
                labeltext: "Password",
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CustomButton(onPressed: () {}, text: "Login"),
              const SizedBox(height: 30),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Navigator  signup screen
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
