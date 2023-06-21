import 'package:flutter/material.dart';
import 'package:eschool/app/appLocalization.dart';

import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/downloadFileCubit.dart';

import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/data/repositories/subjectRepository.dart';

import 'package:eschool/ui/widgets/downloadFileBottomsheetContainer.dart';
import 'package:eschool/ui/widgets/errorMessageOverlayContainer.dart';

import 'package:eschool/utils/constants.dart';
import 'package:eschool/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool/utils/labelKeys.dart';

class UiUtils {
  //This extra padding will add to MediaQuery.of(context).padding.top in orderto give same top padding in every screen

  static double screenContentTopPadding = 15.0;
  static double screenContentHorizontalPadding = 25.0;
  static double screenTitleFontSize = 18.0;
  static double screenContentHorizontalPaddingInPercentage = 0.075;

  static double screenSubTitleFontSize = 14.0;
  static double extraScreenContentTopPaddingForScrolling = 0.0275;
  static double appBarSmallerHeightPercentage = 0.175;

  static double appBarMediumtHeightPercentage = 0.2;

  static double bottomNavigationHeightPercentage = 0.08;
  static double bottomNavigationBottomMargin = 25;

  static double appBarBiggerHeightPercentage = 0.25;
  static double appBarContentTopPadding = 25.0;
  static double bottomSheetTopRadius = 20.0;
  static double subjectFirstLetterFontSize = 20;

  static double defaultProfilePictureHeightAndWidthPercentage = 0.175;

  static double questionContainerHeightPercentage = 0.725;

  static Duration tabBackgroundContainerAnimationDuration =
      Duration(milliseconds: 300);

  static Duration showCaseDisplayDelayInDuration = Duration(milliseconds: 350);
  static Curve tabBackgroundContainerAnimationCurve = Curves.easeInOut;

  static double shimmerLoadingContainerDefaultHeight = 7;

  static int defaultShimmerLoadingContentCount = 6;

  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final List<String> weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  //to give bottom scroll padding in screen where
  //bottom navigation bar is displayed
  static double getScrollViewBottomPadding(BuildContext context) {
    return MediaQuery.of(context).size.height *
            (UiUtils.bottomNavigationHeightPercentage) +
        UiUtils.bottomNavigationBottomMargin * (1.5);
  }

  //to give top scroll padding to screen content
  //
  static double getScrollViewTopPadding(
      {required BuildContext context, required double appBarHeightPercentage}) {
    return MediaQuery.of(context).size.height *
        (appBarHeightPercentage + extraScreenContentTopPaddingForScrolling);
  }

  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String getTranslatedLabel(BuildContext context, String labelKey) {
    return (AppLocalization.of(context)!.getTranslatedValues(labelKey) ??
            labelKey)
        .trim();
  }

  static Future<dynamic> showBottomSheet(
      {required Widget child,
      required BuildContext context,
      bool? enableDrag}) async {
    final result = await showModalBottomSheet(
        enableDrag: enableDrag ?? false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bottomSheetTopRadius),
                topRight: Radius.circular(bottomSheetTopRadius))),
        context: context,
        builder: (_) => child);

    return result;
  }

  static bool isToadyIsInAcademicYear(DateTime firstDate, DateTime lastDate) {
    final currentDate = DateTime.now();

    return (currentDate.isAfter(firstDate) && currentDate.isBefore(lastDate)) ||
        isSameDay(firstDate) ||
        isSameDay(lastDate);
  }

  static bool isSameDay(DateTime dateTime) {
    final currentDate = DateTime.now();
    return (currentDate.day == dateTime.day) &&
        (currentDate.month == dateTime.month) &&
        (currentDate.year == dateTime.year);
  }

  static String getMonthName(int monthNumber) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[monthNumber - 1];
  }

  static int getMonthNumber(String monthName) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return (months.indexWhere((element) => element == monthName)) + 1;
  }

  static List<String> buildMonthYearsBetweenTwoDates(
      DateTime startDate, DateTime endDate) {
    List<String> dateTimes = [];
    DateTime current = startDate;
    while (current.difference(endDate).isNegative) {
      current = current.add(Duration(days: 24));
      dateTimes.add("${getMonthName(current.month)}, ${current.year}");
    }
    dateTimes = dateTimes.toSet().toList();

    return dateTimes;
  }

  static String formatTime(String time) {
    final hourMinuteSecond = time.split(":");
    final hour = int.parse(hourMinuteSecond.first) < 13
        ? int.parse(hourMinuteSecond.first)
        : int.parse(hourMinuteSecond.first) - 12;
    final amOrPm = int.parse(hourMinuteSecond.first) > 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:${hourMinuteSecond[1]} $amOrPm";
  }

  static String formatAssignmentDueDate(
      DateTime dateTime, BuildContext context) {
    final monthName = UiUtils.getMonthName(dateTime.month);
    final hour = dateTime.hour < 13 ? dateTime.hour : dateTime.hour - 12;
    final amOrPm = hour > 12 ? "PM" : "AM";
    return "${UiUtils.getTranslatedLabel(context, dueKey)}, ${dateTime.day} $monthName ${dateTime.year}, ${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $amOrPm";
  }

  static Future<void> showCustomSnackBar(
      {required BuildContext context,
      required String errorMessage,
      required Color backgroundColor,
      Duration delayDuration = errorMessageDisplayDuration}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState?.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }

  static Color getColorFromHexValue(String hexValue) {
    int color = int.parse(hexValue.replaceAll("#", "0xff").toString());
    return Color(color);
  }

  static String getErrorMessageFromErrorCode(
      BuildContext context, String errorCode) {
    return UiUtils.getTranslatedLabel(
        context, ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(errorCode));
  }

  //0 = Pending/In Review , 1 = Accepted , 2 = Rejected
  static String getAssignmentSubmissionStatusKey(int status) {
    if (status == 0) {
      return inReviewKey;
    }
    if (status == 1) {
      return acceptedKey;
    }
    if (status == 2) {
      return rejectedKey;
    }
    if (status == 3) {
      return resubmittedKey;
    }
    return "";
  }

  static String getBackButtonPath(BuildContext context) {
    return Directionality.of(context).name == TextDirection.rtl.name
        ? getImagePath("rtl_back_icon.svg")
        : getImagePath("back_icon.svg");
  }

  static void openDownloadBottomsheet(
      {required BuildContext context,
      required bool storeInExternalStorage,
      required StudyMaterial studyMaterial}) {
    showBottomSheet(
            child: BlocProvider<DownloadFileCubit>(
              create: (context) => DownloadFileCubit(SubjectRepository()),
              child: DownloadFileBottomsheetContainer(
                storeInExternalStorage: storeInExternalStorage,
                studyMaterial: studyMaterial,
              ),
            ),
            context: context)
        .then((result) {
      if (result != null) {
        if (result['error']) {
          showCustomSnackBar(
              context: context,
              errorMessage: getErrorMessageFromErrorCode(
                  context, result['message'].toString()),
              backgroundColor: Theme.of(context).colorScheme.error);
        } else {
          try {
            OpenFilex.open(result['filePath'].toString());
          } catch (e) {
            showCustomSnackBar(
                context: context,
                errorMessage: getTranslatedLabel(
                    context,
                    storeInExternalStorage
                        ? fileDownloadedSuccessfullyKey
                        : unableToOpenKey),
                backgroundColor: Theme.of(context).colorScheme.error);
          }
        }
      }
    });
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  static String dateConverter(
      DateTime myEndDate, BuildContext contxt, bool fromResult) {
    String date;
    //format date & time
    final onlyDate = myEndDate.toString().split(" ");
    DateTime dt = intl.DateFormat("yyyy-MM-dd", "en_US").parse(onlyDate[0]);
    final formattedDate = new intl.DateFormat('dd MMM, yyyy');
    final onlyTime = onlyDate[1];
    final formattedTime = UiUtils.formatTime(onlyTime);
    //check for today or tomorrow or specific date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final checkEndDate =
        DateTime(myEndDate.year, myEndDate.month, myEndDate.day);

    if (checkEndDate == today) {
      date = (fromResult)
          ? "${UiUtils.getTranslatedLabel(contxt, submittedKey)} : $todayKey"
          : "$todayKey, $formattedTime";
    } else if (checkEndDate == tomorrow) {
      date = (fromResult)
          ? "${UiUtils.getTranslatedLabel(contxt, submittedKey)} : $tomorrowKey"
          : "$tomorrowKey, $formattedTime";
    } else {
      date = (fromResult)
          ? '${UiUtils.getTranslatedLabel(contxt, submittedKey)} : ${formattedDate.format(dt)}'
          : '${formattedDate.format(dt)} $formattedTime';
    }
    return date;
  }

  //It will return - if given value is empty
  static String formatEmptyValue(String value) {
    return value.isEmpty ? "-" : value;
  }

  static Future<bool> forceUpdate(String updatedVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    if (updatedVersion.isEmpty) {
      return false;
    }

    bool updateBasedOnVersion = _shouldUpdateBasedOnVersion(
        currentVersion.split("+").first, updatedVersion.split("+").first);

    if (updatedVersion.split("+").length == 1 ||
        currentVersion.split("+").length == 1) {
      return updateBasedOnVersion;
    }

    bool updateBasedOnBuildNumber = _shouldUpdateBasedOnBuildNumber(
        currentVersion.split("+").last, updatedVersion.split("+").last);

    return (updateBasedOnVersion || updateBasedOnBuildNumber);
  }

  static bool _shouldUpdateBasedOnVersion(
      String currentVersion, String updatedVersion) {
    List<int> currentVersionList =
        currentVersion.split(".").map((e) => int.parse(e)).toList();
    List<int> updatedVersionList =
        updatedVersion.split(".").map((e) => int.parse(e)).toList();

    if (updatedVersionList[0] > currentVersionList[0]) {
      return true;
    }
    if (updatedVersionList[1] > currentVersionList[1]) {
      return true;
    }
    if (updatedVersionList[2] > currentVersionList[2]) {
      return true;
    }

    return false;
  }

  static bool _shouldUpdateBasedOnBuildNumber(
      String currentBuildNumber, String updatedBuildNumber) {
    return int.parse(updatedBuildNumber) > int.parse(currentBuildNumber);
  }

  static void showFeatureDisableInDemoVersion(BuildContext context) {
    showCustomSnackBar(
        context: context,
        errorMessage:
            UiUtils.getTranslatedLabel(context, featureDisableInDemoVersionKey),
        backgroundColor: Theme.of(context).colorScheme.error);
  }

  static bool isDemoVersionEnable() {
    //If isDemoVersion is not declarer then it return always false
    return true;
  }

  //0 = Pending , 1 = Paid ˆset according to API response.
  static String getStudentFeesStatusKey(int status) {
    if (status == 0) {
      return pendingKey;
    }
    if (status == 1) {
      return paidKey;
    }
    return "";
  }

  static String formatAmount(
      {required String strVal, required BuildContext context}) {
    return "$strVal ${context.read<AppConfigurationCubit>().getFeesSettings().currencySymbol}";
  }
}

extension emptyPadding on num {
  SizedBox get sizedBoxHeight => SizedBox(height: toDouble());
  SizedBox get sizedBoxWidth => SizedBox(width: toDouble());
}
