import 'package:flutter/material.dart';

class TextFormGlobal extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  const TextFormGlobal(
      {super.key,
      required this.controller,
      required this.text,
      required this.textInputType,
      required this.obscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(55, 61, 65, 1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: const TextStyle(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
