import 'package:flutter/material.dart';
import 'package:weekly/template.dart';

class Intro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Material(
        child: InkWell(
          onTap: () => Navigator.popAndPushNamed(context, Template.name),
          child: Container(
            alignment: Alignment.center,
            color: Colors.indigo,
            child: Text("Weekly meeting", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}