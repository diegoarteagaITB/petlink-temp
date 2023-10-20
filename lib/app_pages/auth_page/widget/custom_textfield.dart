import 'package:flutter/material.dart';

Widget customTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  required TextInputType keyboardType,
  required EdgeInsetsGeometry padding,
  IconButton? suffixIcon,
  bool obscureText = false,
  bool passwordVisible = false,
  Function()? togglePasswordVisibility,
}) {
  return Padding(
    padding: padding,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: labelText,
          floatingLabelStyle:
              TextStyle(color: Theme.of(context).primaryColorDark),
          focusColor: Theme.of(context).primaryColorDark,
          hintStyle: TextStyle(color: Theme.of(context).primaryColorDark),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 70, 93, 71),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 1.5,
            ),
          ),
          suffixIcon: suffixIcon),
    ),
  );
}
