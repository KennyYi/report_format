import 'users/212558683.dart';
import 'users/312558683.dart';
import 'page_info.dart';

class WeeklyReports {

  var _reports = [
    Kenny212558683(),
    Ken312558683()
  ];

  WeeklyPageInfo get(int index) {

    if (index >= 0 && index < _reports.length) {
      return _reports[index];
    } else {
      return null;
    }
  }

  int get length => _reports.length;
}