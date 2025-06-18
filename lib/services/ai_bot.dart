
class AIBot {
  static int getBestMove(List<String> board, String aiPlayer) {
    String humanPlayer = aiPlayer == 'O' ? 'X' : 'O';

    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = aiPlayer;
        int score = minimax(board, 0, false, aiPlayer, humanPlayer);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  static int minimax(List<String> board, int depth, bool isMaximizing, String aiPlayer, String humanPlayer) {
    String? result = checkWinner(board);
    if (result != null) {
      if (result == aiPlayer) return 10 - depth;
      if (result == humanPlayer) return depth - 10;
      return 0; // draw
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = aiPlayer;
          int score = minimax(board, depth + 1, false, aiPlayer, humanPlayer);
          board[i] = '';
          bestScore = score > bestScore ? score : bestScore;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = humanPlayer;
          int score = minimax(board, depth + 1, true, aiPlayer, humanPlayer);
          board[i] = '';
          bestScore = score < bestScore ? score : bestScore;
        }
      }
      return bestScore;
    }
  }

  static String? checkWinner(List<String> board) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      String a = board[pattern[0]];
      String b = board[pattern[1]];
      String c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        return a;
      }
    }

    if (!board.contains('')) return 'Draw';
    return null;
  }
}
