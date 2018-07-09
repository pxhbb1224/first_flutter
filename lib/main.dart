import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:first_flutter/LayoutApp.dart';

void main() => runApp(new RowAndColumn());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

///StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的
  final _biggerFont = const TextStyle(fontSize: 18.0); //来增大字体大小
  final _saved = new Set<WordPair>(); //这个集合存储用户喜欢（收藏）的单词对

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }

  ///构建显示建议单词对的ListView
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // 在奇数行，不添加单词对，该行书湖添加一个分割线widget，像素高为1
        if (i.isOdd) return new Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        // i是ListView 的行数，index 就是 对应行数 在 _suggestion 里
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }, //itemBuilder 值是一个匿名回调函数， 接受两个参数- BuildContext和行迭代器i。迭代器从0开始， 每调用一次该函数，i就会自增1，对于每个建议的单词对都会执行一次。该模型允许建议的单词对列表在用户滚动时无限增长。
    );

  }

  ///这个函数在ListTile中显示每个新词对
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder:(context) {
            final tiles = _saved.map(
                (pair){
                  return new ListTile(
                    title: new Text(
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

            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          }
      )
    );
  }
}
