import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData().then((list) => {
      setState(() {
        _todoList= json.decode(list);
      })
    });
  }

  Future<dynamic> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _todoList.sort((a,b) {
        if(a["isChecked"] && !b["isChecked"]) return 1;
        if(!a["isChecked"] && b["isChecked"]) return -1;
        return 0;
      });
    });
    _saveData();

    return null;
  }

  void _addTodo() {
    setState(() {
      if(_todoController.text == "") return false;

      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _todoController.text;
      newTodo["isChecked"] = false;
      
      _todoList.insert(0, newTodo);
      _todoController.text = "";
    });
    _saveData();
  }

  void _toggleTodo(isChecked, index) {
    setState(() {
      _todoList[index]["isChecked"] = isChecked;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO DO LIST"),
        backgroundColor: Colors.indigo,
        centerTitle: true
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 30),
          child: (
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.indigo, fontSize: 22)
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: RaisedButton(
                    color: Colors.indigo, 
                    child: Text("ADD", style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    onPressed: _addTodo
                  ),
                )
              ]
            )
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
              child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: _todoList.length,
              itemBuilder: buildItem,
            ),
          )
        )
      ])
    );
  }

  Widget buildItem (context, index) {
    return Dismissible(
      key: UniqueKey(), 
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white)
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["isChecked"],
        secondary: CircleAvatar(
          child: Icon(_todoList[index]["isChecked"] 
            ? Icons.check 
            : Icons.error
        )),
        onChanged: (isChecked) => _toggleTodo(isChecked, index),
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedIndex = index;

          _todoList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text("Todo \"${_lastRemoved["title"]}\" removed!"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedIndex, _lastRemoved);
                  _saveData();
                });
              }
            ),
            duration: Duration(seconds: 5),
          );
          
          Scaffold.of(context).removeCurrentSnackBar();    
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);

    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch(e) {
      return null;
    }
  }
}
