import 'package:flutter/material.dart';

class FreetimeWiget extends StatelessWidget {
  const FreetimeWiget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Image.asset(
            'assets/solutions.png',
            height: 150,
            width: 300,
          ),
        ],
      ),
    );
  }
}