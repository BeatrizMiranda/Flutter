import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'dart:io';
import 'dart:typed_data';

class GifPage extends StatelessWidget {

  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_gifData["title"], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              compartilhar(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

void compartilhar(src) async{
  String url = src;
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  await Share.file('Compartilhar', 'arquivo.gif', bytes, 'image/gif', text: "Check the gif I found");
}