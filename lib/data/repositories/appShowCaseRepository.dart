import 'package:eschool/utils/hiveBoxKeys.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppShowCaseRepository {
  static bool getShowHomeScreenShowCase() {
    return Hive.box(showCaseBoxKey).get(showHomeScreenGuideKey) ?? true;
  }

  static void setShowHomeScreenShowCase(bool value) {
    Hive.box(showCaseBoxKey).put(showHomeScreenGuideKey, value);
  }
}
