import 'package:flutter/material.dart';

class DashboardStatistics {
  final String title;
  final int value;
  final Color color;
  final IconData icon;
  final Function? onTap;

  DashboardStatistics({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.onTap,
  });
}
