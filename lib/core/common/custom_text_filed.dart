import 'package:flutter/material.dart';

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    required this.labeltext,
    this.obscureText = false,
    this.keyboardType,
    required this.prefixIcon,
    this.validator,
    this.focusNode,
    this.controller,
    this.onSaved,
  });
  final String labeltext;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final IconData prefixIcon;
  final void Function(String?)? onSaved;
  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  void onpressed() {
    setState(() {
      isVisibility = !isVisibility;
    });
  }

  bool isVisibility = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      onSaved: widget.onSaved,

      focusNode: widget.focusNode,
      validator: widget.validator,
      obscureText: widget.obscureText && !isVisibility,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labeltext,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        suffixIcon: widget.obscureText
            ? !isVisibility
                  ? IconButton(
                      icon: Icon(Icons.visibility_off),
                      onPressed: onpressed,
                    )
                  : IconButton(
                      onPressed: onpressed,
                      icon: Icon(Icons.visibility),
                    )
            : null,
        prefixIcon: Icon(widget.prefixIcon),
      ),
    );
  }
}
