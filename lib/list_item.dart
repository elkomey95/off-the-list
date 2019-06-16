import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  String _itemName;

  String _dateCreated;

  int _id;

  ListItem(this._itemName, this._dateCreated);

  //make ListItem object (Custom object) by mapping the keys
  ListItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get itemName => _itemName;

  String get dateCreated => _dateCreated;

  int get id => _id;

  //create map variable to hold the data and to be transformed later back into objects
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    if (_id != null) map["id"] = _id;

    return map;
  }

  ListItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                _itemName,
                //overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.2),
              ),
              new Container(
                margin: const EdgeInsets.all(5.0),
                child: new Text(
                  "Created on : $_dateCreated",
                  style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
