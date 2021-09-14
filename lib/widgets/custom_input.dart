import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/utils/colors.dart';

class CustomInput extends StatelessWidget {
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType keyboardType;
  // final Function(String) onChanged;
  final TextEditingController controller;
  // final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool obscureText;
  CustomInput({
    required this.validator,
    required this.hintText,
    required this.keyboardType,
    // required this.onChanged,
    required this.controller,
    // required this.focusNode,
    required this.textInputAction,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    bool _obscureText = obscureText;
    // bool _obscureText = obscureText ?? false;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: CustomColors().grey.withOpacity(0.1),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: TextFormField(
          obscureText: _obscureText,
          controller: controller,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: CustomColors().grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
