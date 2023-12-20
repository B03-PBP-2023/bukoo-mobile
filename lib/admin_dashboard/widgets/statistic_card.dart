import 'package:bukoo/admin_dashboard/models/dashboard_statisics.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final DashboardStatistics data;
  const StatisticCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      surfaceTintColor: Colors.transparent,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data.icon!,
                  color: data.color,
                  size: 32.0,
                ),
                const SizedBox(width: 8),
                Text(
                  data.value.toString(),
                  style: TextStyle(
                    color: data.color,
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
