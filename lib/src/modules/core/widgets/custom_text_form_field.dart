import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.label,
      this.focus,
      this.validator,
      this.onChanged,
      this.onSubmitted,
      this.textInputType})
      : super(key: key);

  final TextEditingController controller;
  final String label;
  final FocusNode? focus;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? textInputType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focus,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      validator: widget.validator,
      textInputAction: TextInputAction.next,
      keyboardType: widget.textInputType,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}
