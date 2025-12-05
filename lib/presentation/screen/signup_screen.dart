import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_filed.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController emailC;
  late TextEditingController passwordC;
  late TextEditingController fullnameC;
  late TextEditingController phoneC;
  late TextEditingController usernameC;

  late FocusNode focusNodeMail;
  late FocusNode focusNodePass;
  late FocusNode focusNodePhone;
  late FocusNode focusNodeUsername;
  late FocusNode focusNodeFullname;

  @override
  void initState() {
    emailC = TextEditingController();
    passwordC = TextEditingController();
    fullnameC = TextEditingController();
    phoneC = TextEditingController();
    usernameC = TextEditingController();

    focusNodeMail = FocusNode();
    focusNodePass = FocusNode();
    focusNodePhone = FocusNode();
    focusNodeUsername = FocusNode();
    focusNodeFullname = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    fullnameC.dispose();
    phoneC.dispose();
    usernameC.dispose();
    focusNodeMail.dispose();
    focusNodePass.dispose();
    focusNodePhone.dispose();
    focusNodeUsername.dispose();
    focusNodeFullname.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_sharp),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "please fill in the details  to countinue",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  //=============================fullname
                  CustomTextFiled(
                    focusNode: focusNodeFullname,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodeUsername);
                    },
                    controller: fullnameC,
                    labeltext: "full Name",
                    prefixIcon: Icons.person_3_outlined,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  //======================== username
                  CustomTextFiled(
                    focusNode: focusNodeUsername,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodePhone);
                    },
                    controller: usernameC,
                    labeltext: "User name",
                    prefixIcon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  //============================ Phone
                  CustomTextFiled(
                    focusNode: focusNodePhone,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodeMail);
                    },
                    controller: phoneC,
                    labeltext: "Phone",
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  //email
                  CustomTextFiled(
                    focusNode: focusNodeMail,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodePass);
                    },
                    controller: emailC,
                    labeltext: "E-mail",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  //password
                  const SizedBox(height: 16),
                  CustomTextFiled(
                    focusNode: focusNodePass,
                    controller: passwordC,
                    labeltext: "Password",
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(onPressed: () {}, text: "sign Up"),
                  const SizedBox(height: 30),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "have an account ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: "Login",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Theme.of(context).primaryColor,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //Navigator  login screen
                                Navigator.pop(context);
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
        ),
      ),
    );
  }
}
