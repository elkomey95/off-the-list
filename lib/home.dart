import 'package:flutter/material.dart';
import 'offlist.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Off The List"),
        backgroundColor: Colors.black54,

      ),
      body: new NotoDoScreen(),
    );
  }
}
