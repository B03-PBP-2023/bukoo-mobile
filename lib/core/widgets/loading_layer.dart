import 'package:flutter/material.dart';

class LoadingLayer extends StatelessWidget {
  final bool isLoading;
  const LoadingLayer({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          child: Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ))),
    );
  }
}
