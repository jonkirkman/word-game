import 'dart:math';
import 'package:werds/dictionary_usa.dart';

final Set<String> alphabet = Set.from('abcdefghijklmnnopqrstuvwxyz'.split(''));
var random = Random();

enum ResultType { valid, notFound, missingRequired, tooShort, alreadyFound }

class Result {
  ResultType type = ResultType.notFound;
  String message = '';

  Result.valid() { type = ResultType.valid; }
  Result.notFound() { type = ResultType.notFound; }
  Result.missingRequired() { type = ResultType.missingRequired; }
  Result.tooShort() { type = ResultType.tooShort; }
  Result.alreadyFound() { type = ResultType.alreadyFound; }
}

Set<String> reduceDictionary(int minLength, Set<String>requiredLetters, Set<String>allowedLetters) {
  Set<String> _dict = Set.from(dictionary);
  // print(_dict.length);
  // print("minLength: $minLength \nrequiredLetters: $requiredLetters \nallowedLetters:$allowedLetters");

  _dict.removeWhere((word) => word.length < minLength);
  // print("retaining words longer than $minLength -- ${_dict.length}");

  for (var letter in requiredLetters) {
    _dict.retainWhere((word) => word.contains(letter));
    // print("retaining words with $letter -- ${_dict.length}");
  }

  for (var letter in disallowedLetters(allowedLetters)) {
    _dict.removeWhere((word) => word.contains(letter));
    // print("removing words with $letter -- ${_dict.length}");
  }

  // print(allowedLetters);
  // print(_dict.length);
  // print(_dict);
  return _dict;
}

Set<String> disallowedLetters(Set<String>allowedLetters) {
  Set<String> letterPool = Set.from(alphabet);
  for (var letter in allowedLetters) {
    letterPool.remove(letter);
  }

  return letterPool;
}

Set<String> randomLetters(int count, Set<String> skip) {
  Set<String> letters = {};

  Set<String> letterPool = Set.from(alphabet);
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
  Set<String> allowedLetters = {};
  Set<String> requiredLetters = {};
  Set<String> foundWords = {};
  Set<String> dict = {};
  String attempt = '';

  Game() {
    requiredLetters = randomLetters(1, {});
    allowedLetters = randomLetters(6, requiredLetters);
    allowedLetters.addAll(requiredLetters);

    dict = reduceDictionary(4, requiredLetters, allowedLetters);
  }

  Result submitAttempt() {
    print("checking $attempt");
    // is the attempt long enough?
    if (attempt.length < minLength) {
      return Result.tooShort();
    }
    // have we already found this word?
    if (foundWords.contains(attempt)) {
      return Result.alreadyFound();
    }
    // does the attempt include the required letters?
    if (!requiredLetters.every((element) => attempt.contains(element))) {
      return Result.missingRequired();
    }
    // is the attempt found in the reduced dictionary?
    if (dict.contains(attempt)) {
      foundWords.add(attempt);
      attempt = '';
      return Result.valid();
    }
    // default return is the implicit else case
    return Result.notFound();
  }

  _buildAttempt(String letter) {
    attempt += letter;
    print(attempt);
  }
}
