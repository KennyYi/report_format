import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PdfWidget;
import 'package:weekly/data/page_info.dart';

import 'weekly_data.dart';
import 'weekly_reports.dart';

class ExportHelper {

  final pdf = PdfWidget.Document(
    pageMode: PdfPageMode.fullscreen,
  );

  final String _fileName = "weekly.pdf";

  Future<void> export(BuildContext context) async {

    var reports = WeeklyReports();

    for (int pageIndex = 0; pageIndex < reports.length; pageIndex++) {
      pdf.addPage(_generatePage(context, reports.get(pageIndex)));
    }

    var data = pdf.save();

    switch(defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        _export(_fileName, data);
        break;
      default:
        // Not support web yet
        print("$defaultTargetPlatform is not supported platform.");
    }
  }

  Future<void> _export(String fileName, Uint8List data) async {

    final file = await getApplicationDocumentsDirectory().then((value) => File("${value.path}/$_fileName"));

    print("file path >> ${file.path}");
    return file.writeAsBytes(data).whenComplete(() => print("complete"));
  }

  PdfWidget.Page _generatePage(BuildContext context, WeeklyPageInfo presenter) {

    return PdfWidget.Page(
        orientation: PdfWidget.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return PdfWidget.Container(
              color: PdfColor.fromInt(Colors.white.value),
              child: PdfWidget.Container(
                padding: PdfWidget.EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: PdfWidget.BoxDecoration(
                  border: PdfWidget.BoxBorder(
                    color: PdfColor.fromInt(Colors.indigo.value),
                    width: 3.0,
                    left: true, right: true, top: true, bottom: true
                  )
                ),
                child: PdfWidget.Row(
                    children: [
                      PdfWidget.Expanded(
                          flex: 1,
                          child: PdfWidget.Column(
                              crossAxisAlignment: PdfWidget.CrossAxisAlignment.start,
                              children: [
                                PdfWidget.Container(
                                  height: 25.0,
                                  child: PdfWidget.Text("WEEKLY REVIEW", style: PdfWidget.TextStyle(fontSize: 20.0)),
                                ),
                                _getGroupTitleByType(ContentType.DONE),
                                presenter.done.export(pdf: pdf),
                              ]
                          )
                      ),
                      PdfWidget.SizedBox(width: 10.0),
                      PdfWidget.Expanded(
                          flex: 1,
                          child: PdfWidget.Column(
                              crossAxisAlignment: PdfWidget.CrossAxisAlignment.start,
                              children: [
                                PdfWidget.Container(
                                  alignment: PdfWidget.Alignment.topRight,
                                  height: 25.0,
                                  child: PdfWidget.Text("${presenter.team} / ${presenter.name}", style: PdfWidget.TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: PdfWidget.FontWeight.bold
                                  )),
                                ),
                                _getGroupTitleByType(ContentType.TODO),
                                PdfWidget.Expanded(
                                    flex: 2,
                                    child: presenter.todo.export(pdf: pdf)
                                ),
                                _getGroupTitleByType(ContentType.ETC),
                                PdfWidget.Expanded(
                                    flex: 1,
                                    child: presenter.etc.export(pdf: pdf)
                                ),
                              ]
                          )
                      ),
                    ]
                ),
              )
          );
        }
    );
  }

  PdfWidget.Widget _getGroupTitleByType(ContentType type) {

    String title;
    if (type == ContentType.TODO) title = "TODO";
    else if (type == ContentType.DONE) title = "DONE";
    else title = "Team contribution & Personal Growth";

    return PdfWidget.Container(
      width: double.infinity,
      color: PdfColor.fromInt(Colors.grey.value),
      alignment: PdfWidget.Alignment.centerLeft,
      height: 40.0,
      padding: PdfWidget.EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      margin: PdfWidget.EdgeInsets.only(top: 8.0, bottom: 3.0),
      child: PdfWidget.Text(title,
        style: PdfWidget.TextStyle(
          color: PdfColor.fromInt(Colors.black.value),
          fontWeight: PdfWidget.FontWeight.bold,
          fontSize: 20.0
        ),
      ),
    );
  }
}