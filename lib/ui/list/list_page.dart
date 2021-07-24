import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_1/ui/route/app_route.dart';
import 'package:flutter_application_1/ui/hook/use_router.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends HookWidget {
  // final _suggestions = <WordPair>[];
  // final _saved = <WordPair>{};
  // final saved = useState(<WordPair>{});

  // void _pushSaved() {
  //   router.push(
  //     FavoriteListRoute(
  //       savedPair: _saved,
  //       // savedPair: saved.value),
  //     ),
  //   );
  // Navigator.of(context).push(
  //   MaterialPageRoute<void>(
  //     builder: (BuildContext context) {
  //       final tiles = _saved.map(
  //         (WordPair pair) {
  //           return ListTile(
  //             title: Text(
  //               pair.asPascalCase,
  //               style: _biggerFont,
  //             ),
  //           );
  //         },
  //       );
  //       final divided = ListTile.divideTiles(
  //         context: context,
  //         tiles: tiles,
  //       ).toList();

  //       return Scaffold(
  //         appBar: AppBar(
  //           title: Text('Saved Suggestions'),
  //         ),
  //         body: ListView(children: divided),
  //       );
  //     },
  //   ),
  // );
  // }

  @override
  Widget build(BuildContext context) {
    final _suggestions = <WordPair>[];
    final _saved = <WordPair>{};
    final router = useRouter();
    void _pushSaved() {
      print(_saved);
      router.push(
        FavoriteListRoute(
          savedPair: _saved,
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        // body: _buildSuggestions(),
        body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return const Divider(); /*2*/

              final index = i ~/ 2; /*3*/
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10)); /*4*/
              }
              final pair = _suggestions[index];
              print('## ListView');
              print(_saved);

              return ListTilePanel(
                  pair: pair,
                  defaultIsfavorite: _saved.contains(pair),
                  onTap: (bool isfavorite) {
                    if (isfavorite) {
                      _saved.add(pair);
                    } else {
                      _saved.remove(pair);
                    }
                  });
            }));
  }
}

class ListTilePanel extends HookWidget {
  ListTilePanel(
      {Key? key,
      required this.pair,
      required this.defaultIsfavorite,
      required this.onTap})
      : super(key: key);

  final WordPair pair;
  final bool defaultIsfavorite;
  final Function onTap;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final isfavorite = useState(defaultIsfavorite);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        isfavorite.value ? Icons.favorite : Icons.favorite_border,
        color: isfavorite.value ? Colors.red : null,
      ),
      onTap: () {
        // NEW lines from here...
        isfavorite.value = !isfavorite.value;
        onTap(isfavorite.value);
      },
    );
  }
}
