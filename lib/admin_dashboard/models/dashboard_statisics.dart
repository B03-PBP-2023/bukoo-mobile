import 'package:flutter/material.dart';

class DashboardStatistics {
  final String title;
  final int value;
  final Color? color;
  final IconData? icon;

  DashboardStatistics({
    required this.title,
    required this.value,
    this.color,
    this.icon,
  });
}
