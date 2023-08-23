// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:client/common/widgets/snack_bar.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
              labelText: 'Email or Username',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.never),
          validator: (value) {
            if (value!.isEmpty) {
              showSnackBar(context, 'Please fill the Form');
            }
            return null;
          },
        ),
      ),
    );
  }
}
