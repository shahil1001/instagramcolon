import 'package:flutter/material.dart';
class TextFeildWidget extends StatelessWidget {
String hinttext;
TextInputType textInputType;
bool obscure;
TextEditingController controller;
TextFeildWidget(this.hinttext, this.textInputType,this.obscure,this.controller);

@override
  Widget build(BuildContext context) {
    OutlineInputBorder border= OutlineInputBorder(
        borderSide:Divider.createBorderSide(context)
    );
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: textInputType,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
        filled: true,
          hintText:hinttext,
          border:border,
          focusedBorder: border,
        enabledBorder: border
    ));
  }
}