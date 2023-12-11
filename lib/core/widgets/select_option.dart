import 'package:flutter/material.dart';

class SelectOption<T> extends StatelessWidget {
  final T selectedRole;
  final T value;
  final void Function() onChanged;
  final Widget child;
  const SelectOption(
      {super.key,
      required this.selectedRole,
      required this.value,
      required this.onChanged,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Container(
        decoration: BoxDecoration(
          color: selectedRole == value
              ? Theme.of(context).colorScheme.secondary
              : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
        ),
        child: ListTileTheme(
          textColor: selectedRole == value
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
          selectedColor: Colors.white,
          iconColor: selectedRole == value
              ? Colors.white
              : Theme.of(context).colorScheme.secondary,
          child: ListTile(
            title: child,
            selected: selectedRole == value,
          ),
        ),
      ),
    );
  }
}
