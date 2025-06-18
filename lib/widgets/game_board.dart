import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final Function(int) onTap;
  final List<int>? winLine;
  final Animation<double> lineAnimation;
  final bool showLine;

  const GameBoard({
    super.key,
    required this.board,
    required this.onTap,
    required this.winLine,
    required this.lineAnimation,
    required this.showLine,
  });

  Color getInkColor(String mark) {
    if (mark == 'X') return Colors.blue.shade800;
    if (mark == 'O') return Colors.red.shade700;
    return Colors.black;
  }

  Offset getOffset(int index) {
    double cellSize = 100;
    int row = index ~/ 3;
    int col = index % 3;
    double x = col * cellSize + cellSize / 2;
    double y = row * cellSize + cellSize / 2;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // 👈 Move board down
              ...List.generate(3, (row) {
                return Column(
                  children: [
                    Row(
                      children: List.generate(3, (col) {
                        int index = row * 3 + col;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => onTap(index),
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: col < 2 ? Colors.black : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                board[index],
                                style: TextStyle(
                                  fontSize: 56,
                                  fontFamily: 'Notebook',
                                  color: getInkColor(board[index]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    if (row < 2)
                      Container(height: 2, color: Colors.black),
                  ],
                );
              }),
            ],
          ),
          if (showLine && winLine != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: lineAnimation,
                builder: (context, child) {
                  Offset start = getOffset(winLine![0]);
                  Offset end = getOffset(winLine![2]);
                  // Adjusted offset for alignment with moved board
                  Offset centerOffset = const Offset(24, 20);
                  return CustomPaint(
                    painter: LinePainter(
                      start + centerOffset,
                      Offset.lerp(start, end, lineAnimation.value)! + centerOffset,
                      board[winLine![0]] == 'X'
                          ? Colors.blue.shade800
                          : Colors.red.shade700,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  LinePainter(this.start, this.end, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color;
  }
}
