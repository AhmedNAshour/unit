import 'package:flutter/material.dart';
import 'package:unit/components/forms/text_field_container.dart';
import 'package:unit/constants.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    Key key,
    this.hintText,
    this.onChanged,
    this.validator,
    this.obsecureText,
    this.labelText,
    this.initialValue,
    this.icon,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator validator;
  final bool obsecureText;
  final String labelText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: kPrimaryColor,
          ),
          icon: Icon(
            icon,
            color: kSecondaryColor,
          ),
          hintText: hintText,
          focusColor: kPrimaryColor,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
