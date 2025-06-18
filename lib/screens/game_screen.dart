import 'package:flutter/material.dart';
import '../services/ai_bot.dart';
import '../widgets/score_board.dart';
import '../widgets/game_board.dart';
import '../widgets/game_dialog.dart';

class GameScreen extends StatefulWidget {
  final bool isSinglePlayer;

  const GameScreen({super.key, required this.isSinglePlayer});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  int scoreX = 0;
  int scoreO = 0;
  List<int>? winLine;
  bool showLine = false;

  late AnimationController _controller;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _lineAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void handleTap(int index) {
    if (board[index] == '' && !showLine) {
      setState(() {
        board[index] = currentPlayer;
        final winner = checkWinner(currentPlayer);
        if (winner != null) {
          winLine = winner;
          showLine = true;
          _controller.forward().then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (currentPlayer == 'X') scoreX++;
              if (currentPlayer == 'O') scoreO++;
              GameDialog.show(
                context: context,
                message: '$currentPlayer Wins!',
                onOk: resetBoard,
              );
            });
          });
        } else if (!board.contains('')) {
          showLine = false;
          GameDialog.show(
            context: context,
            message: 'It\'s a Draw!',
            onOk: resetBoard,
          );
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (widget.isSinglePlayer && currentPlayer == 'O') {
            makeBotMove();
          }
        }
      });
    }
  }

  void makeBotMove() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted || showLine) return;

    int index = AIBot.getBestMove(board, 'O');
    if (index == -1) return;

    setState(() {
      board[index] = 'O';
      final winner = checkWinner('O');
      if (winner != null) {
        winLine = winner;
        showLine = true;
        _controller.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            scoreO++;
            GameDialog.show(
              context: context,
              message: 'O Wins!',
              onOk: resetBoard,
            );
          });
        });
      } else if (!board.contains('')) {
        showLine = false;
        GameDialog.show(
          context: context,
          message: 'It\'s a Draw!',
          onOk: resetBoard,
        );
      } else {
        currentPlayer = 'X';
      }
    });
  }

  List<int>? checkWinner(String player) {
    List<List<int>> winPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (var pos in winPositions) {
      if (board[pos[0]] == player &&
          board[pos[1]] == player &&
          board[pos[2]] == player) {
        return pos;
      }
    }
    return null;
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      showLine = false;
      winLine = null;
      _controller.reset();

      if (widget.isSinglePlayer && currentPlayer == 'O') {
        makeBotMove();
      }
    });
  }

  void resetGame() {
    setState(() {
      resetBoard();
      scoreX = 0;
      scoreO = 0;
    });
  }

  Color getInkColor(String mark) {
    if (mark == 'X') return Colors.blue.shade800;
    if (mark == 'O') return Colors.red.shade700;
    return Colors.black;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/notebook.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    widget.isSinglePlayer ? 'Single Player' : 'Two Player',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Notebook',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Current Turn: ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Notebook',
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: currentPlayer,
                          style: TextStyle(
                            color: getInkColor(currentPlayer),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ScoreBoard(scoreX: scoreX, scoreO: scoreO),
                  const SizedBox(height: 30),
                  GameBoard(
                    board: board,
                    onTap: handleTap,
                    winLine: winLine,
                    lineAnimation: _lineAnimation,
                    showLine: showLine,
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: resetGame,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 28,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Restart",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Notebook',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 2,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
