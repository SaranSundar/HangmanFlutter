import 'package:flutter/material.dart';
import 'package:hangman/word_helper.dart';

class HangMan extends StatefulWidget {
  @override
  _HangManState createState() => _HangManState();
}

class _HangManState extends State<HangMan> {
  bool showNewGame;
  bool showGameOver;
  int livesLeft;
  int imageNum;
  Set<String> wrongLetters;
  Set<String> rightLetters;
  String guessWord;
  bool isWinner;

  @override
  void initState() {
    startNewGame();
    super.initState();
  }

  void startNewGame() {
    showNewGame = true;
    showGameOver = false;
    isWinner = false;
    livesLeft = 5;
    imageNum = 0;
    wrongLetters = new Set();
    rightLetters = new Set();
    guessWord = getRandomWord().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createGameScreen(),
    );
  }

  Widget createGameScreen() {
    if (showGameOver) {
      return createGameOverScreen();
    }
    if (showNewGame) {
      return createShowNewGameScreen();
    }
    return Container(
      color: Colors.deepPurpleAccent,
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text(
                    livesLeft.toString(),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )
                ],
              ),
            ),
            createHangManImage(),
            createGuessWord(),
            createGameKeyboard()
          ],
        ),
      ),
    );
  }

  Widget createHangManImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Image.asset(
        'assets/images/$imageNum.png',
        height: 200,
      ),
    );
  }

  String createFormattedGuessWord() {
    String formattedGuessWord = "";
    for (int i = 0; i < guessWord.length; i++) {
      String letter = guessWord.substring(i, i + 1).toUpperCase();
      if (rightLetters.contains(letter)) {
        formattedGuessWord += letter.toUpperCase();
      } else {
        formattedGuessWord += "_";
      }
      if (i < guessWord.length - 1) {
        formattedGuessWord += " ";
      }
    }
    return formattedGuessWord;
  }

  Widget createGuessWord() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        createFormattedGuessWord(),
        style: TextStyle(color: Colors.white, fontSize: 50),
      ),
    );
  }

  void updateGameWithGuess(String guessLetter) {
    guessLetter = guessLetter.toUpperCase();
    if (guessWord.contains(guessLetter)) {
      rightLetters.add(guessLetter);
      isWinner = true;
      for (int i = 0; i < guessWord.length; i++) {
        if (!rightLetters.contains(guessWord.substring(i, i + 1))) {
          isWinner = false;
          break;
        }
      }
      if(isWinner){
        showGameOver = true;
      }
    } else {
      wrongLetters.add(guessLetter);
      livesLeft -= 1;
      imageNum += 1;
      if (livesLeft <= 0) {
        livesLeft = 0;
        imageNum = 6;
        showGameOver = true;
        isWinner = false;
      }
    }
    // Will now update UI
    setState(() {});
  }

  Widget createGameOverScreen() {
    String text = "";
    if (isWinner) {
      text = "You Won!";
    } else {
      text = "You Lost";
    }
    return Container(
      color: Colors.deepPurpleAccent,
      constraints: BoxConstraints.expand(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 45),
            ),
          ),
          Image.asset('assets/images/gallow.png'),
          Container(
            width: 250,
            height: 60,
            child: RaisedButton(
              onPressed: () {
                startNewGame();
                showNewGame = false;
                setState(() {});
              },
              child: Text(
                "Play Again",
                style: TextStyle(fontSize: 25),
              ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  MaterialColor getButtonColor(String guessLetter) {
    if (rightLetters.contains(guessLetter)) {
      return Colors.blueGrey;
    } else if (wrongLetters.contains(guessLetter)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  Widget createGameKeyboard() {
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        children: List.generate(
            alphabet.length,
            (index) => Container(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    color: getButtonColor(alphabet.substring(index, index + 1)),
                    onPressed: () {
                      String guessLetter = alphabet.substring(index, index + 1);
                      if (!(rightLetters.contains(guessLetter) ||
                          wrongLetters.contains(guessLetter))) {
                        updateGameWithGuess(guessLetter);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      alphabet.substring(index, index + 1),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )));
  }

  Widget createShowNewGameScreen() {
    return Container(
      color: Colors.deepPurpleAccent,
      constraints: BoxConstraints.expand(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Text(
              "HANGMAN",
              style: TextStyle(color: Colors.white, fontSize: 45),
            ),
          ),
          Image.asset('assets/images/gallow.png'),
          Container(
            width: 150,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  showNewGame = false;
                });
              },
              child: Text(
                "Start",
                style: TextStyle(fontSize: 25),
              ),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
