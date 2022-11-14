import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../main.dart';
import '../../../../presentation/pages/Schedule.dart';
import '../../components/constats.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    icon: '@mipmap/ic_launcher',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    colorized: true,
    playSound: true,

  );
  final IOSNotificationDetails _iOSNotificationDetails =
      const IOSNotificationDetails();

  scheduledNotification({
    required String title,
    required int hour,
    required int minute,
    required int repeat,
    required int reminder,
    required String time,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      createUniqueId(),
      'Todo',
      'You Must do a $title at $time',
      _convertTime(hour, minute, repeat, reminder),
      NotificationDetails(
          android: _androidNotificationDetails, iOS: _iOSNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes, int repeat, int reminder) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      if (repeat == 24) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      } else if (repeat == 168) {
        scheduleDate = scheduleDate.add(const Duration(days: 7));
      } else if (repeat == 720) {
        scheduleDate = scheduleDate.add(const Duration(days: 30));
      }
    }
    if (scheduleDate.isAfter(now)) {
      if (reminder == 10) {
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 10));
      } else if (reminder == 30) {
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 30));
      } else if (reminder == 60) {
        scheduleDate = scheduleDate.subtract(const Duration(minutes: 60));
      }
    }

    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future selectNotification(
    String? payload,
  ) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    } else {
      debugPrint("Notification Done");
    }
    await Navigator.push(MyApp.navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => const Schedule()));
  }
}

late BuildContext context;

Future onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Schedule(),
              ),
            );
          },
        )
      ],
    ),
  );
}
