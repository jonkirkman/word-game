import 'package:flutter/material.dart';
import 'package:werds/game.dart';

class GameplayPage extends StatefulWidget {
  Game game;

  GameplayPage(this.game, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameplayPageState(game);
}

class _GameplayPageState extends State {
  Game _game = Game();
  Result _lastResult = Result.none();

  _GameplayPageState(this._game);

  void _addLetter(letter) {
    setState(() { _game.attempt += letter;});
  }

  void _backspace() {
    setState(() {
      if (_game.attempt.isNotEmpty) {
        _game.attempt = _game.attempt.substring(0, _game.attempt.length-1);
      }
    });
  }

  void _submit() {
    setState(() { _lastResult = _game.submitAttempt();});
  }

  void _shuffle() {
    setState(() { _game.shuffle(); });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _buttons = [];
    for (var letter in _game.allowedLetters) {
      var style = Theme.of(context).textTheme.headline4;
      if (_game.requiredLetters.contains(letter)) {
        style = style!.apply(color: Colors.blue);
      }
      var button = OutlinedButton(
          onPressed: (){_addLetter(letter);},
          child: Text(letter, style: style)
      );
      _buttons.add(button);
    }

    List<Widget> _foundWordList = [];
    for (var word in _game.foundWords) {
      _foundWordList.add(Text(word));
    }

    return Scaffold(body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top:32, bottom: 32),
            child: Column(
                children: [
                  Text(_game.attempt, style: Theme.of(context).textTheme.headline2),
                  Text(_lastResult.message, style: Theme.of(context).textTheme.caption),
                ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(onPressed: _shuffle, icon: const Icon(Icons.change_circle, color: Colors.blue)),
            IconButton(onPressed: _backspace, icon: const Icon(Icons.backspace, color: Colors.blue)),
            IconButton(onPressed: _submit, icon: const Icon(Icons.check_circle, color: Colors.blue)),
          ],),
          Expanded(
              child: GridView.count(
                  crossAxisCount: 4,
                  padding: const EdgeInsets.all(12),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: _buttons
              )
          ),
          Text("Found ${_game.foundWords.length} of ${_game.dict.length} possible words"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              scrollDirection: Axis.vertical,
              children: _foundWordList,
            ),
          )
        ],
      ),
    ));
  }
}