import 'package:flutter/material.dart';
import 'list_item.dart';
import 'database_client.dart';
import 'date_formatter.dart';

class NotoDoScreen extends StatefulWidget {
  @override
  _NotoDoScreenState createState() => new _NotoDoScreenState();
}

class _NotoDoScreenState extends State<NotoDoScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ListItem> _itemList = <ListItem>[];


  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    ListItem listItem = new ListItem(text, dateFormatted());
    int savedItemId = await db.saveItem(listItem);

    ListItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);

    });


    print("Item saved id: $savedItemId");
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return new Card(
                    color: Colors.white10,
                    child: new ListTile(
                      title: _itemList[index],
                      onLongPress: () => _udateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemName),
                        child:  new Icon(Icons.remove_circle,
                          color: Colors.redAccent,),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );

                }),
          ),

          new Divider(
            height: 1.0,
          )
        ],
      ),


      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Item",
                    hintText: "eg. Don't buy stuff",
                    icon: new Icon(Icons.note_add)
                ),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancel"))

      ],
    );
    showDialog(context: context,
        builder:(_) {
          return alert;

        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      // ListItem ListItem = ListItem.fromMap(item);
      setState(() {
        _itemList.add(ListItem.map(item));
      });
      // print("Db items: ${ListItem.itemName}");
    });

  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });


  }

  _udateItem(ListItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,

                decoration: new InputDecoration(
                    labelText:  "Item",
                    hintText: "eg. Don't buy stuff",
                    icon: new Icon(Icons.update)),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ListItem newItemUpdated = ListItem.fromMap(
                  {"itemName": _textEditingController.text,
                    "dateCreated" : dateFormatted(),
                    "id" : item.id
                  });

              _handleSubmittedUpdate(index, item);//redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readNoDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);

            },
            child: new Text("Update")),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: new Text("Cancel"))
      ],
    );
    showDialog(context:
    context ,builder: (_) {
      return alert;
    });



  }

  void _handleSubmittedUpdate(int index, ListItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;

      });

    });
  }
}
