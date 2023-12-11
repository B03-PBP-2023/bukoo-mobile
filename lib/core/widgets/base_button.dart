import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  const BaseButton(
      {super.key,
      required this.onPressed,
      required this.child,
      required this.foregroundColor,
      required this.backgroundColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize:
            MaterialStateProperty.all<Size>(const Size(double.infinity, 48.0)),
        foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: borderColor),
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
