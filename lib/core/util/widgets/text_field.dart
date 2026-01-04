// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    this.isPasswordField = false,
    required this.controller,
    this.validator,
    this.autovalidateMode = AutovalidateMode.always,
    this.keyboardType,
    this.textInputAction,
    this.initialValue,
    this.readOnly,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.style,
    this.label,
    this.maxlines,
    this.minlines,
    this.radius,
    this.autofocus = false,
    this.onChanged,
  });
  final String hintText;
  final bool isPasswordField;
  final TextEditingController controller;
  final FormFieldValidator<String?>? validator;
  final AutovalidateMode autovalidateMode;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  bool? readOnly = false;
  Color? color;
  TextStyle? style;
  int? minlines;
  int? maxlines;
  TextInputAction? textInputAction;
  double? radius;
  final Function(String)? onChanged;
  final bool autofocus;
  final String? label;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePassword = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          (widget.label != null)
              ? Text(
                  widget.label ?? '',
                  style: const TextStyle(fontSize: 14),
                )
              : const SizedBox.shrink(),
          TextFormField(
            minLines: widget.minlines,
            maxLines: widget.maxlines,
            // expands: true,
            // style: const TextStyle(
            //   fontSize: 12,
            //   color: Colors.black,
            // ),
            enabled: widget.readOnly == true ? false : true,
            style: Theme.of(context).textTheme.headlineSmall,
            initialValue: widget.initialValue,
            controller: widget.controller,
            obscureText: hidePassword,
            validator: widget.validator,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,

            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 15,
                right: 15,
              ),
              hintText: widget.hintText,
              hintStyle:
                  widget.style ??
                  const TextStyle(fontSize: 12, color: Colors.grey),
              // border: InputBorder.none,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 10),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
              filled: true,

              fillColor: widget.color ?? Theme.of(context).canvasColor,
              focusColor: Colors.white,
              prefixIcon: widget.prefixIcon,
              // suffixIconColor: Theme.of(context).indicatorColor,
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        if (hidePassword) {
                          hidePassword = false;
                        } else {
                          hidePassword = true;
                        }
                        setState(() {});
                      },
                    )
                  : widget.suffixIcon,
            ),
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
