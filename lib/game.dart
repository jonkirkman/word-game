import 'dart:math';
import 'package:werds/dictionary_usa.dart';

final Set<String> alphabet = Set.from('abcdefghijklmnnopqrstuvwxyz'.split(''));
var random = Random();

enum ResultType { none, valid, notFound, missingRequired, tooShort, alreadyFound }

class Result {
  ResultType type = ResultType.none;
  String message = '';

  Result.none(): 
    type = ResultType.none,
    message = "";
  Result.valid(): 
    type = ResultType.valid,
    message = "Good work!";
  Result.notFound(): 
    type = ResultType.notFound,
    message = "Not found";
  Result.missingRequired(): 
    type = ResultType.missingRequired,
    message = "missing the required letter";
  Result.tooShort(): 
    type = ResultType.tooShort,
    message = "too short";
  Result.alreadyFound(): 
    type = ResultType.alreadyFound,
    message = "already found";
}

List<String> reduceDictionary(int minLength, List<String>requiredLetters, List<String>allowedLetters) {
  List<String> _dict = List.from(dictionary);

  _dict.removeWhere((word) => word.length < minLength);

  for (var letter in requiredLetters) {
    _dict.retainWhere((word) => word.contains(letter));
  }

  for (var letter in disallowedLetters(allowedLetters)) {
    _dict.removeWhere((word) => word.contains(letter));
  }

  return _dict;
}

List<String> disallowedLetters(List<String>allowedLetters) {
  List<String> letterPool = List.from(alphabet);
  for (var letter in allowedLetters) {
    letterPool.remove(letter);
  }

  return letterPool;
}

List<String> randomLetters(int count, List<String> skip) {
  List<String> letters = [];

  List<String> letterPool = List.from(alphabet);
  for (var letter in skip) {
    letterPool.remove(letter);
  }

  for (var i = 0; i < count; i++ ) {
    var index = random.nextInt(letterPool.length);
    // print(index);
    var letter = letterPool.elementAt(index);
    letterPool.remove(letter);
    letters.add(letter);
  }

  return letters;
}

class Game {
  int minLength = 4;
  List<String> allowedLetters = [];
  List<String> requiredLetters = [];
  List<String> foundWords = [];
  List<String> dict = [];
  String attempt = '';

  Game() {
    requiredLetters = randomLetters(1, []);
    allowedLetters = randomLetters(6, requiredLetters);
    allowedLetters.addAll(requiredLetters);

    dict = reduceDictionary(4, requiredLetters, allowedLetters);
  }

  void shuffle() {
    allowedLetters.shuffle();
  }

  Result submitAttempt() {
    // is the attempt long enough?
    if (attempt.length < minLength) {
      return Result.tooShort();
    }
    // have we already found this word?
    if (foundWords.contains(attempt)) {
      attempt = '';
      return Result.alreadyFound();
    }
    // does the attempt include the required letters?
    if (!requiredLetters.every((element) => attempt.contains(element))) {
      attempt = '';
      return Result.missingRequired();
    }
    // is the attempt found in the reduced dictionary?
    if (dict.contains(attempt)) {
      foundWords.add(attempt);
      foundWords.sort();
      attempt = '';
      return Result.valid();
    }
    // default return is the implicit else case
    attempt = '';
    return Result.notFound();
  }

}
