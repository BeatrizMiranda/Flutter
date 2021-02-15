import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:udemy_aula/Gif/GifPage.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;
  var _controllerSearch = TextEditingController();

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=kb0Y9FZcNNGamSal5eQdx5fsshEoSfJ9&limit=19&offset=$_offset&&rating=g');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=kb0Y9FZcNNGamSal5eQdx5fsshEoSfJ9&q=$_search&limit=19&offset=$_offset&rating=g&lang=en');
    }

    return json.decode(response.body);
  }

  void clearSearch() {
    setState(() {
      _search = null;
      _controllerSearch.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: GestureDetector(
                  child: Image.network(
                      'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
                  onTap: () {
                    setState(() {
                      _offset = 0;
                      clearSearch();
                    });
                  }),
            ),
            centerTitle: true),
        backgroundColor: Colors.black,
        body: Column(children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 40),
              child: TextField(
                  controller: _controllerSearch,
                  decoration: InputDecoration(
                    labelText: "Pesquise!",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: clearSearch,
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  onSubmitted: (text) {
                    setState(() {
                      text != '' ? _search = text : _search = null;
                      _offset = 0;
                    });
                  })),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (ctx, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ));
                    default:
                      if (snapshot.hasError) return Container();
                      return _createGifTable(ctx, snapshot);
                  }
                }),
          )
        ]));
  }

  Widget _createGifTable(ctx, snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: (snapshot.data["data"].length + 1),
        itemBuilder: (ctx, index) {
          if (index < snapshot.data["data"].length) {
            return GestureDetector(
              onLongPress: () => compartilhar(snapshot.data["data"][index]
                  ["images"]["fixed_height"]["url"]),
              onTap: () {
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            GifPage(snapshot.data["data"][index])));
              },
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _offset += 19;
                    print(_offset);
                  });
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, color: Colors.white, size: 50),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text('Load more...',
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                      )
                    ]),
              ),
            );
          }
        });
  }
}

void compartilhar(src) async {
  String url = src;
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  await Share.file('Compartilhar', 'arquivo.gif', bytes, 'image/gif',
      text: "Check the gif I found");
}
