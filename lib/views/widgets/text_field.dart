import 'package:dexter_health/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.hintText,
      this.labelText,
      required this.controller,
      this.width = 343,
      this.suffixIcon,
      this.onTap,
      this.readOnly = false,
      this.keyboardType,
      this.inputFormatters,
      this.validator})
      : super(key: key);
  final String? hintText;
  final String? labelText;
  final TextEditingController controller;
  final double width;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        const SizedBox(height: 16),
        Container(
          width: width,

          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Color.fromARGB(251, 243, 247, 246),
          ),
          child: TextFormField(
            controller: controller,
            // maxLength: ,
            // maxLengthEnforcement: ,
          readOnly: readOnly,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.black87,
                fontSize: 16,
                fontFamily: "",
                fontWeight: FontWeight.w400),

            cursorHeight: 20,
            cursorColor: green,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: const Color(0xFFB7B7B9),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: green)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
            ),

            onTap: onTap,
            onSaved: (newValue) {
              printOnlyInDebug(newValue);
            },
            validator: validator,
          ),
        ),
      ],
    );
  }
}

