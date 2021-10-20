import 'package:flutter/material.dart';
import 'package:werds/game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Yet another word game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Game _game = Game();
  Result _lastResult = Result.tooShort();

  void _restart() {
    setState(() {
      _game = Game();
    });
  }

  void _addLetter(letter) {
    setState(() {
      _game.attempt += letter;
    });
  }

  void _backspace() {
    setState(() {
      if (_game.attempt.isNotEmpty) {
        _game.attempt = _game.attempt.substring(0, _game.attempt.length-1);
      }
    });
  }

  void _submit() {
    setState(() {
      _lastResult = _game.submitAttempt();
      print(_game.foundWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<Widget> buttons = [];
    for (var letter in _game.allowedLetters) {
      var style = Theme.of(context).textTheme.headline4;
      if (_game.requiredLetters.contains(letter)) {
        style = style!.apply(color: Colors.blue);
      }
      var button = OutlinedButton(
          onPressed: (){_addLetter(letter);},
          child: Text(letter, style: style)
      );
      buttons.add(button);
    }

    List<Widget> _foundWordList = [];
    for (var word in _game.foundWords) {
      _foundWordList.add(Text(word));
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top:32, bottom: 32),
              child: Column(
                  children: [
                    Text(_game.attempt, style: Theme.of(context).textTheme.headline2),
                    Text('${_lastResult.type}', style: Theme.of(context).textTheme.caption),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              IconButton(onPressed: _restart, icon: const Icon(Icons.change_circle, color: Colors.blue)),
              IconButton(onPressed: _backspace, icon: const Icon(Icons.backspace, color: Colors.blue)),
              IconButton(onPressed: _submit, icon: const Icon(Icons.check_circle, color: Colors.blue)),
            ],),
            Expanded(
                child: GridView.count(
                    crossAxisCount: 4,
                    padding: const EdgeInsets.all(12),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: buttons
                )
            ),
            Text("Found ${_game.foundWords.length} of ${_game.dict.length} possible words"),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(12),
                scrollDirection: Axis.vertical,
                children: _foundWordList,
              ),
            )
          ],
        ),
      ),
    );
  }
}



