import 'package:eschool_teacher/utils/labelKeys.dart';

class ErrorMessageKeysAndCode {
  static const String defaultErrorMessageKey = "defaultErrorMessage";
  static const String noInternetKey = "noInternet";
  static const String invalidLogInCredentialsKey = "invalidLogInCredentials";

  static const String assignmentAlreadySubmittedKey =
      "assignmentAlreadySubmitted";

  static String invalidUserDetailsKey = "invalidUserDetails";

  static String invalidPasswordKey = "invalidPassword";

  static String canNotSendResetPasswordRequestKey =
      "canNotSendResetPasswordRequest";

  static String nameAlreadyTakenKey = "nameAlreadyTaken";

  //These are ui side error codes

  static const String permissionNotGivenCode = "300";
  static const String noInternetCode = "301";
  static const String defaultErrorMessageCode = "302";

  //Visit here to watch error message keys and codes
  //https://docs.google.com/document/d/1JsRC_DXvWZ64GRZE1vkQOrHMfb_ghFtsQh9xJJruAIk/edit?usp=sharing
  static String getErrorMessageKeyFromCode(String errorCode) {
    //
    if (errorCode == "101") {
      return invalidLogInCredentialsKey;
    }
    if (errorCode == "104") {
      return assignmentAlreadySubmittedKey;
    }

    if (errorCode == "107") {
      return invalidUserDetailsKey;
    }

    if (errorCode == "108") {
      return canNotSendResetPasswordRequestKey;
    }

    if (errorCode == "109") {
      return invalidPasswordKey;
    }
    if (errorCode == "112") {
      return featureDisableInDemoVersionKey;
    }
    if (errorCode == permissionNotGivenCode) {
      return "permissionsNotGivenKey";
    }
    if (errorCode == "113") {
      return nameAlreadyTakenKey;
    }
    if (errorCode == noInternetCode) {
      return noInternetKey;
    }
    if (errorCode == defaultErrorMessageCode) {
      return defaultErrorMessageKey;
    } else {
      return defaultErrorMessageKey;
    }
  }
}
