import '../page_info.dart';
import '../weekly_data.dart';

class Ken312558683 extends WeeklyPageInfo {


  String get sso => "312558683";

  String get name => "Ken";

  String get team => "Test";


  WeeklyData get done => WeeklyData(
    // TODO Input your report
    content: "NewFI Mobile\n"
        "* Release (1.1.770)\n"
        "- Bug fix [DONE]\n"
        "\n"
        "THUNDER POC\n"
        "* UI Upgrade [in progress]\n"
        "* long long long long long long long long long long long long long work what I did last week"
  );

  WeeklyData get todo => WeeklyData(
    // TODO Input your report
    content: "NewFI Mobile\n"
        "* Bug fix\n"
        "\n"
        "THUNDER POC\n"
        "\n"
  );

  WeeklyData get etc => WeeklyData(
    // TODO Input your reports
    content: "Flutter\n"
  );
}