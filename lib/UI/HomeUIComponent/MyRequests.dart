import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,title: Text(
          "Requests",
          style: TextStyle(
              fontFamily: "Gotik",
              color: Colors.black12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.0,
              fontSize: 16.4),),
      ),
    );
  }
}
