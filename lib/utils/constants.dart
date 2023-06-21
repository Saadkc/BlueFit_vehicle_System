import 'package:eschool/utils/labelKeys.dart';

//database urls
//Please add your admin panel url here and make sure you do not add '/' at the end of the url

const String baseUrl = "https://e-school.wrteam.in";
const String databaseUrl = "$baseUrl/api/";

//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);
//home menu bottom sheet animation duration

const Duration homeMenuBottomSheetAnimationDuration =
    Duration(milliseconds: 300);

//Change slider duration
const Duration changeSliderDuration = Duration(seconds: 5);

//Number of latest notices to show in home container
const int numberOfLatestNotciesInHomeScreen = 3;

//notification channel keys
const String notificationChannelKey = "basic_channel";

//Set demo verion this when upload this code to codecanyon
//Is demo version
//const bool isDemoVersion = false;

String getExamStatusTypeKey(String examStatus) {
  if (examStatus == "0") {
    return upComingKey;
  }
  if (examStatus == "1") {
    return onGoingKey;
  }
  return completedKey;
}

List<String> examFilters = [allExamsKey, upComingKey, onGoingKey, completedKey];
