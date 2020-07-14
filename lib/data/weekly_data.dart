import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PdfWidget;

/// Template(content:
///   "NewFI Mobile
///   * Release [DONE]
///   - binaries
///   Thunder POC
///   * UI [IN PROGRESS]");
///
/// NewFI Mobile
///   * Release [DONE]
///     - binaries
///
/// Thunder POC
///   * UI [IN PROGRESS]

class WeeklyData {

  final String sso;
  final String content;

  WeeklyData({
    this.sso,
    this.content
  });

  final TextStyle _groupTitleStyle = TextStyle(color: Colors.indigo, fontSize: 25.0, fontWeight: FontWeight.bold);
  final TextStyle _contentStyle = TextStyle(color: Colors.black87, fontSize: 23.0);

  final PdfWidget.TextStyle _groupTitleStyleForExport = PdfWidget.TextStyle(color: PdfColor.fromInt(Colors.indigo.value), fontSize: 22.0, fontWeight: PdfWidget.FontWeight.bold);
  final PdfWidget.TextStyle _contentStyleForExport = PdfWidget.TextStyle(color: PdfColor.fromInt(Colors.black87.value), fontSize: 20.0);

  Widget build() {

    List<Widget> converted = List();
    List<String> lines = content.split("\n");

    lines.forEach((line) {

      if (line.startsWith("img:")) { // Image tag
        try {
          var image = line.substring(5, line.indexOf('}')).split(':');

          if (image.length == 2) {
            var size = image[1].split('x');
            converted.add(Image.asset("assets/images/$sso/${image[0]}", width: double.parse(size[0]), height: double.parse(size[1]),));
          } else {
            converted.add(Image.asset("assets/images/$sso/${image[0]}", fit: BoxFit.fitWidth,));
          }
        } catch (e) {
          print(e);
        }
      } else {
        List<TextSpan> spans = List();
        int splitPosition = line.indexOf("[");
        ProgressState state = ProgressState.NULL;

        if (splitPosition < 0)
          splitPosition = line.length;
        else {
          var type = line.substring(splitPosition, line.length);

          if (type.toUpperCase().contains("DONE")) {
            state = ProgressState.DONE;
          } else if (type.toUpperCase().contains("IN PROGRESS")) {
            state = ProgressState.IN_PROGRESS;
          } else {
            state = ProgressState.ETC;
          }
        }

        TextStyle style = _contentStyle;
        if (line.startsWith("*")) {
          spans.add(
              TextSpan(
                text: "  ${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        } else if (line.startsWith("-")) {
          spans.add(
              TextSpan(
                text: "    ${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        } else {
          style = _groupTitleStyle;
          spans.add(
              TextSpan(
                text: "${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        }

        if (splitPosition < line.length) {
          spans.add(TextSpan(text: " [", style: style));
          spans.add(TextSpan(
              text: "${state.toString().substring(
                  state.toString().indexOf('.') + 1).replaceAll("_", " ")}",
              style: new TextStyle(color: _getStateColor(state),
                  fontSize: (style == _groupTitleStyle) ? 25.0 : 23.0)
          ));
          spans.add(TextSpan(text: "]", style: style));
        }

        converted.add(RichText(text: TextSpan(children: spans),));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: converted,
    );
  }

  Color _getStateColor(ProgressState state) {

    if (state == ProgressState.IN_PROGRESS) return Colors.yellow;
    else if (state == ProgressState.DONE) return Colors.green;
    else return Colors.deepOrangeAccent;
  }

  PdfWidget.Widget export({@required PdfWidget.Document pdf}) {

    List<PdfWidget.Widget> converted = List();
    List<String> lines = content.split("\n");

    lines.forEach((line) {

      if (line.startsWith("img:")) { // Image tag

        try {
          var image = line.substring(5, line.indexOf('}')).split(':');
          _convertAssetImageToUint8List("assets/images/$sso/${image[0]}").then(
            (bytes) {
              if (image.length == 2) {
                var size = image[1].split('x');
                converted.add(PdfWidget.Image(
                  PdfImage.file(pdf.document, bytes: bytes),
                  width: double.parse(size[0]), height: double.parse(size[1]),
                ));
              } else {
                converted.add(PdfWidget.Image(
                    PdfImage.file(pdf.document, bytes: bytes),
                    fit: PdfWidget.BoxFit.fitWidth
                ));
              }
            }
          );
        } catch (e) {
          print(e);
        }
      } else {
        List<PdfWidget.TextSpan> spans = List();
        int splitPosition = line.indexOf("[");
        ProgressState state = ProgressState.NULL;

        if (splitPosition < 0)
          splitPosition = line.length;
        else {
          var type = line.substring(splitPosition, line.length);

          if (type.toUpperCase().contains("DONE")) {
            state = ProgressState.DONE;
          } else if (type.toUpperCase().contains("IN PROGRESS")) {
            state = ProgressState.IN_PROGRESS;
          } else {
            state = ProgressState.ETC;
          }
        }

        PdfWidget.TextStyle style = _contentStyleForExport;

        if (line.startsWith("*")) {
          spans.add(
              PdfWidget.TextSpan(
                text: "  ${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        } else if (line.startsWith("-")) {
          spans.add(
              PdfWidget.TextSpan(
                text: "    ${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        } else {
          style = _groupTitleStyleForExport;
          spans.add(
              PdfWidget.TextSpan(
                text: "${line.substring(0, splitPosition)}",
                style: style,
              )
          );
        }

        if (splitPosition < line.length) {
          spans.add(PdfWidget.TextSpan(text: " [", style: style));
          spans.add(PdfWidget.TextSpan(
            text: "${state.toString().substring(
              state.toString().indexOf('.') + 1).replaceAll("_", " ")}",
            style: new PdfWidget.TextStyle(color: _getExportStateColor(state),
              fontSize: (style == _groupTitleStyleForExport) ? 20.0 : 18.0)
          ));
          spans.add(PdfWidget.TextSpan(text: "]", style: style));
        }

        converted.add(PdfWidget.RichText(text: PdfWidget.TextSpan(children: spans)));
      }
    });

    return PdfWidget.Column(
      crossAxisAlignment: PdfWidget.CrossAxisAlignment.start,
      mainAxisAlignment: PdfWidget.MainAxisAlignment.start,
      children: converted,
    );
  }

  PdfColor _getExportStateColor(ProgressState state) {

    PdfColor color;

    if (state == ProgressState.IN_PROGRESS) color = PdfColor.fromInt(Colors.yellow.value);
    else if (state == ProgressState.DONE) color = PdfColor.fromInt(Colors.green.value);
    else return color = PdfColor.fromInt(Colors.deepOrangeAccent.value);

    return color;
  }

  Future<Uint8List> _convertAssetImageToUint8List(String path) async {
    return await rootBundle.load(path).then(
      (data) => data.buffer.asUint8List()
    );
  }
}

enum ProgressState {
  IN_PROGRESS,
  DONE,
  ETC,
  NULL
}

enum ContentType {
  DONE,
  TODO,
  ETC // Team contribution & Personal Growth
}