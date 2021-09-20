import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // Add english_words package

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(primaryColor: Colors.white),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return const Divider();
        }
        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final item = _suggestions[index].asPascalCase;
        return Dismissible(
            key: Key(item),
            onDismissed: (direction) {
              setState(() {
                _saved.remove(_suggestions[index]);
                _suggestions.removeAt(index);
              });
            },
            background: Container(color: Colors.red),
            child: _buildRow(_suggestions[index]));
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: InkWell(
          child: Text(pair.asPascalCase, style: _biggerFont),
          onTap: () {
            alreadySaved
                ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Only edit non-favorite item'),
                    duration: Duration(seconds: 2),
                  ))
                : openAlertBox(pair);
          },
        ),
        trailing: InkWell(
          child: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          onTap: () {
            setState(() {
              alreadySaved ? _saved.remove(pair) : _saved.add(pair);
            });
          },
        ));
  }

  openAlertBox(WordPair pair) {
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[Text("Alter name item")],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter new first string",
                          border: InputBorder.none,
                        ),
                        controller: myController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter new second string",
                          border: InputBorder.none,
                        ),
                        controller: myController2,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (myController.text == "" &&
                              myController2.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Invalid inputs'),
                              duration: Duration(seconds: 2),
                            ));
                          } else if (myController.text == null ||
                              myController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Invalid first input'),
                              duration: Duration(seconds: 2),
                            ));
                          } else if (myController2.text == null ||
                              myController2.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Invalid second input'),
                              duration: Duration(seconds: 2),
                            ));
                          } else {
                            _suggestions[_suggestions.indexOf(pair)] =
                                WordPair(myController.text, myController2.text);
                            Navigator.pop(context);
                          }
                        });
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
