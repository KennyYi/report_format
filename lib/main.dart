import 'package:flutter/material.dart';
import 'package:weekly/intro.dart';
import 'package:weekly/outro.dart';
import 'package:weekly/template.dart';

void main() {
  runApp(Presentation());
}

class Presentation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weekly",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Intro(),
        Template.name : (context) => Template(),
        Outro.name : (context) => Outro(),
      },
    );
  }
}
