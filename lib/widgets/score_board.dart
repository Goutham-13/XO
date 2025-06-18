import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int scoreX;
  final int scoreO;

  const ScoreBoard({
    super.key,
    required this.scoreX,
    required this.scoreO,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 70,
      child: Stack(
        children: [
          // Vertical divider
          Positioned(
            left: 80,
            top: 0,
            bottom: 0,
            child: Container(width: 1.5, color: Colors.black),
          ),
          // Horizontal middle line
          Positioned(
            left: 0,
            right: 0,
            top: 35,
            child: Container(height: 1.5, color: Colors.black),
          ),
          // Player labels
          Positioned(
            top: 6,
            left: 0,
            right: 80,
            child: Center(
              child: Text(
                'X',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Notebook',
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 80,
            right: 0,
            child: Center(
              child: Text(
                'O',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Notebook',
                  color: Colors.red,
                ),
              ),
            ),
          ),
          // Player scores
          Positioned(
            top: 42,
            left: 0,
            right: 80,
            child: Center(
              child: Text(
                '$scoreX',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Notebook',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 42,
            left: 80,
            right: 0,
            child: Center(
              child: Text(
                '$scoreO',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Notebook',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
