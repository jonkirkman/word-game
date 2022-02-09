import 'package:flutter/material.dart';
import 'package:werds/game.dart';

class WelcomePage extends StatelessWidget {
  Game game;

  WelcomePage(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: DecoratedBox(
        decoration: const BoxDecoration( color: Colors.blue ),
        child: Column(
            children: [
              const Text('Words.'),
              OutlinedButton(
                onPressed: (){ game = Game(); }, 
                child: const Text('new game')
              )
            ]
        )
      )
    );
  }
}