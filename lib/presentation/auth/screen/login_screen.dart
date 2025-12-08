import 'package:chat_app/config/routing/app_routing.dart';
import 'package:chat_app/core/common/custom_button.dart';
import 'package:chat_app/core/common/custom_text_filed.dart';
import 'package:chat_app/core/helper/app_validation.dart';
import 'package:chat_app/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //==========formkey
  final GlobalKey<FormState> _formlKey = GlobalKey<FormState>();

  //============controler
  late TextEditingController email;
  late TextEditingController password;

  //========================focusNode
  late FocusNode focusNodeemail;
  late FocusNode focusNodpass;

  //====================initstate
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    focusNodeemail = FocusNode();
    focusNodpass = FocusNode();
    super.initState();
  }
  //===============dispose

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
          key: _formlKey,
          child: SingleChildScrollView(
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
                  validator: AppValidators.validateEmail,
                  focusNode: focusNodeemail,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNodpass);
                  },
                  controller: email,
                  labeltext: "E-mail",
                  prefixIcon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                //password
                const SizedBox(height: 16),
                CustomTextFiled(
                  validator: AppValidators.validatePassword,
                  focusNode: focusNodpass,
                  controller: password,
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
                    if (state is Authfinish) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouting.home,
                        (_) => false,
                      );
                    }
                  },
                  builder: (final context, final state) {
                    return CustomButton(
                      onPressed: () {
                        //?=========================================ontap login

                        FocusScope.of(context).unfocus();
                        if (_formlKey.currentState?.validate() ?? false) {
                          context.read<AuthCubit>().login(
                            email: email.text,
                            password: password.text,
                          );
                        }
                      },

                      text: state is AuthLoading ? null : "login",
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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
                          text: "Don't have an account ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //Navigator  signup screen
                              Navigator.pushNamed(context, AppRouting.signup);
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
    );
  }
}
