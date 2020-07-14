import 'package:flutter/material.dart';
//import './data/users/weekly';
import 'data/export_helper.dart';

class Outro extends StatelessWidget {

  static final String name = "Outro";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Material(
        child: InkWell(
          onTap: () => ExportHelper().export(context),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.indigo,
                      width: 5.0
                  )
              ),
              child: Center(
                child: Text("End", style: TextStyle(color: Colors.indigo, fontSize: 50.0, fontWeight: FontWeight.bold),),
              ),
            )
          )
        ),
      ),
    );
  }
}