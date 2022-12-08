import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.onPressed, required this.buttonText}) : super(key: key);

  final Function onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.teal),
          onPressed: () {
            onPressed();
          },
          child:  Text(buttonText,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white))),
    );
  }
}
