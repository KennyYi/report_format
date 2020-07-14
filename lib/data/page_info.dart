import 'package:weekly/data/weekly_data.dart';

abstract class WeeklyPageInfo {

  String get sso;

  String get name;

  String get team;

  WeeklyData get done;

  WeeklyData get todo;

  WeeklyData get etc;
}