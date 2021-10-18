import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordPairs {
  final List _suggestions = <WordPair>[];
  List get suggestions => _suggestions;

  WordPairs();

  void addWords() {
    _suggestions.addAll(generateWordPairs().take(10));
  }

  returnLength() {
    return _suggestions.length;
  }

  returnItem(index) {
    return _suggestions[index];
  }

  void removeItem(index) {
    _suggestions.removeAt(index);
  }

  returnIndex(pair) {
    return _suggestions.indexOf(pair);
  }

  void updateItem(index, word) {
    _suggestions[index] = word;
  }
}
