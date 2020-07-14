import 'package:flutter/material.dart';
import 'outro.dart';
import 'package:weekly/data/weekly_reports.dart';
import 'package:weekly/data/weekly_data.dart';

class Template extends StatefulWidget {

  static final String name = "Template";

  @override
  State<StatefulWidget> createState() => _Template();
}

class _Template extends State<Template> with SingleTickerProviderStateMixin {

  WeeklyReports _reports = WeeklyReports();
  int _index = 0;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animationController.forward();
  }

  @override
  void dispose() {

    if (_animationController != null) {
      _animationController.stop();
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
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
            child:
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 30.0,
                            child: Text("WEEKLY REVIEW", style: TextStyle(fontSize: 25.0))
                        ),
                        _getGroupTitleByType(ContentType.DONE),
                        _reports.get(_index).done.build(),
                      ],
                    )
                ),
                SizedBox(width: 10.0,),
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            height: 30.0,
                            child: Text("${_reports.get(_index).team} / ${_reports.get(_index).name}", style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                            )),
                          ),
                          _getGroupTitleByType(ContentType.TODO),
                          Expanded(
                              flex: 2,
                              child: _reports.get(_index).todo.build()
                          ),
                          _getGroupTitleByType(ContentType.ETC),
                          Expanded(
                              flex: 1,
                              child: _reports.get(_index).etc.build()
                          ),
                        ]
                    )
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.navigate_before),
              onPressed: () => setState(() {
                if (_index > 0) _index--;
              }),
            ),
            SizedBox(width: 20.0,),
            FloatingActionButton(
              child: Icon(Icons.navigate_next),
              onPressed: () {
                if (_index < _reports.length - 1) {
                  setState(() {
                    print("_index: $_index");
                    _index++;
                  });
                } else {
                  Navigator.popAndPushNamed(context, Outro.name);
                }
              },
            ),
          ],
        )
    );
  }

  Widget _getGroupTitleByType(ContentType type) {

    String title;
    if (type == ContentType.TODO) title = "TODO";
    else if (type == ContentType.DONE) title = "DONE";
    else title = "Team contribution & Personal Growth";

    return Container(
      width: double.infinity,
      color: Colors.black12,
      alignment: Alignment.centerLeft,
      height: 45.0,
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Text(title,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0
        ),
      ),
    );
  }
}