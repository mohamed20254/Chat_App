import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_filed.dart';
import 'package:chat_app/core/helper/app_validation.dart';
import 'package:chat_app/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  //======================controler
  late TextEditingController emailC;
  late TextEditingController passwordC;
  late TextEditingController fullnameC;
  late TextEditingController phoneC;
  late TextEditingController usernameC;
  //=============================focusNodes
  late FocusNode focusNodeMail;
  late FocusNode focusNodePass;
  late FocusNode focusNodePhone;
  late FocusNode focusNodeUsername;
  late FocusNode focusNodeFullname;

  //==========================initState
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

  //=================================dispose
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
            key: _key,
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
                    validator: AppValidators.validateName,
                    focusNode: focusNodeFullname,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodeUsername);
                    },
                    controller: fullnameC,
                    labeltext: "full Name",
                    prefixIcon: CupertinoIcons.person,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  //======================== username
                  CustomTextFiled(
                    validator: AppValidators.validateName,
                    focusNode: focusNodeUsername,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodePhone);
                    },
                    controller: usernameC,
                    labeltext: "User name",
                    prefixIcon: CupertinoIcons.at,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  //============================ Phone
                  CustomTextFiled(
                    validator: AppValidators.validatePhone,
                    focusNode: focusNodePhone,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodeMail);
                    },
                    controller: phoneC,
                    labeltext: "Phone",
                    prefixIcon: CupertinoIcons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  //email
                  CustomTextFiled(
                    validator: AppValidators.validateEmail,
                    focusNode: focusNodeMail,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNodePass);
                    },
                    controller: emailC,
                    labeltext: "E-mail",
                    prefixIcon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  //password
                  const SizedBox(height: 16),
                  CustomTextFiled(
                    validator: AppValidators.validatePassword,
                    focusNode: focusNodePass,
                    controller: passwordC,
                    labeltext: "Password",
                    prefixIcon: CupertinoIcons.lock,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (final context, final state) {
                      if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.messgae)));
                      }
                    },
                    builder: (final context, final state) {
                      return CustomButton(
                        onPressed: () {
                          //?============================================= ontap create account
                          FocusScope.of(context).unfocus();
                          if (_key.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().creatAcount(
                              email: emailC.text,
                              phone: phoneC.text,
                              fullName: fullnameC.text,
                              userName: usernameC.text,
                              password: passwordC.text,
                            );
                          }
                        },

                        text: state is AuthLoading ? null : "Create Account",
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: " already have an account ",
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
