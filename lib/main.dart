import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));

  bool isPlayerX = true; // X starts first
  bool gameFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gameFinished
                  ? 'Game Over!'
                  : 'Player ${isPlayerX ? 'X' : 'O'}\'s turn',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () {
                    if (!gameFinished && board[row][col].isEmpty) {
                      setState(() {
                        board[row][col] = isPlayerX ? 'X' : 'O';
                        isPlayerX = !isPlayerX;
                        checkWinner();
                      });
                    }
                  },
                  child: Container(
                    color: Colors.blueGrey,
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  void checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0].isNotEmpty) {
        announceWinner(board[i][0]);
        return;
      }
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i].isNotEmpty) {
        announceWinner(board[0][i]);
        return;
      }
    }

    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0].isNotEmpty) {
      announceWinner(board[0][0]);
      return;
    }

    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2].isNotEmpty) {
      announceWinner(board[0][2]);
      return;
    }

    if (board.every((row) => row.every((cell) => cell.isNotEmpty))) {
      announceWinner('Draw');
    }
  }

  void announceWinner(String winner) {
    setState(() {
      gameFinished = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(
                winner == 'Draw' ? 'It\'s a draw!' : 'Player $winner wins!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: Text('Play Again'),
              ),
            ],
          );
        },
      );
    });
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      isPlayerX = true;
      gameFinished = false;
    });
  }
}
