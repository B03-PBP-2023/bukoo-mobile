import 'package:flutter/material.dart';

class ReaderProfile extends StatefulWidget {
  const ReaderProfile({super.key});

  @override
  State<ReaderProfile> createState() => ReaderProfilePage();
}

class ReaderProfilePage extends State<ReaderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 390,
        height: 844,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFADC4CE)),
        child: Stack(
          children: [
            Positioned(
              left: 43,
              top: 275,
              child: Container(
                width: 146,
                height: 114,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
                )
              )
            )
          ]
        )
      )
    );
  }
}
