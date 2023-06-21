import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eschool/app/routes.dart';
import 'package:eschool/ui/screens/home/homeScreen.dart';
import 'package:eschool/utils/constants.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class NotificationUtility {
  static String generalNotificationType = "general";

  static String assignmentlNotificationType = "assignment";

  static Future<void> setUpNotificationService(
      BuildContext buildContext) async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    //ask for permission
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      //if permission is provisionnal or authorised
      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        initNotificationListener(buildContext);
      }

      //if permission denied
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      return;
    }
    initNotificationListener(buildContext);
  }

  static void initNotificationListener(BuildContext buildContext) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      onMessageOpenedAppListener(remoteMessage, buildContext);
    });
  }

  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
    //perform any background task if needed here
  }

  static void foregroundMessageListener(RemoteMessage remoteMessage) async {
    await FirebaseMessaging.instance.getToken();
    createLocalNotification(dimissable: true, message: remoteMessage);
  }

  static void onMessageOpenedAppListener(
      RemoteMessage remoteMessage, BuildContext buildContext) {
    _onTapNotificationScreenNavigateCallback(
        remoteMessage.data['type'] ?? "", remoteMessage.data);
  }

  static void _onTapNotificationScreenNavigateCallback(
      String notificationType, Map<String, dynamic> data) {
    if (notificationType == generalNotificationType) {
      UiUtils.rootNavigatorKey.currentState?.pushNamed(Routes.noticeBoard);
    } else if (notificationType == assignmentlNotificationType) {
      HomeScreen.homeScreenKey.currentState?.navigateToAssignmentContainer();
    }
  }

  static Future<void> initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: notificationChannelKey,
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        vibrationPattern: highVibrationPattern,
      ),
    ]);
  }

  static Future<bool> isLocalNotificationAllowed() async {
    final notificationPermission = await Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    _onTapNotificationScreenNavigateCallback(
        (receivedAction.payload ?? {})['type'] ?? "",
        Map.from(receivedAction.payload ?? {}));
  }

  static Future<void> createLocalNotification(
      {required bool dimissable, required RemoteMessage message}) async {
    String title = message.notification?.title ?? "";
    String body = message.notification?.body ?? "";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        autoDismissible: dimissable,
        title: title,
        body: body,
        id: 1,
        showWhen: true,
        locked: !dimissable,
        payload: {"type": message.data['type'] ?? ""},
        channelKey: notificationChannelKey,
      ),
    );
  }
}
