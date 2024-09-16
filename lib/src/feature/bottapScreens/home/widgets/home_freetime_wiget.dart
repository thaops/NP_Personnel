import 'package:flutter/material.dart';

class HomeFreetimeWiget extends StatelessWidget {
  const HomeFreetimeWiget({super.key});

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