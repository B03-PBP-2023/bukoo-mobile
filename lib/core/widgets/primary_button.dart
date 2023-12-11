import 'package:bukoo/core/widgets/base_button.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  const PrimaryButton(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      borderColor: Theme.of(context).colorScheme.secondary,
      child: child,
    );
  }
}
