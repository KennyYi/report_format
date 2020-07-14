import '../page_info.dart';
import '../weekly_data.dart';

class Kenny212558683 extends WeeklyPageInfo {

  String get sso => "212558683";

  String get name => "Kenny";

  String get team => "NewFI";

  WeeklyData get done => WeeklyData(
    sso: sso,
    content: "NewFI Mobile\n"
        "* Release (1.1.770)\n"
        "- Bug fix [DONE]\n"
        "\n"
        "THUNDER POC\n"
        "* UI Upgrade [in progress]\n"
        "img:{eight.jpg:300x100}\n"
        "img:{eight.jpg}\n"
  );

  WeeklyData get todo => WeeklyData(
    sso: sso,
    content: "NewFI Mobile\n"
        "* Bug fix\n"
        "\n"
        "THUNDER POC\n"
        "\n"
  );

  WeeklyData get etc => WeeklyData(
    sso: sso,
    content: "Flutter\n"
        "Kotlin\n"
        "Made Weekly report template with Flutter"
  );
}