import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:todo_algroiza210/core/util/notification_handler/utilities.dart';


Future<void> onTimeNotification() async {
  await AwesomeNotifications().createNotification(content: NotificationContent(
      id: createUniqueId(), channelKey: 'basic_channel',
  title: "Task Created",
  body: "Check Schedule Now",
    notificationLayout: NotificationLayout.Default,
  ));
}

Future<void> createScheduleNotifications(
    NotificationDateAndTime notificationSchedule , Map model,) async {
  await AwesomeNotifications().createNotification(content: NotificationContent(
    id: createUniqueId(),
    channelKey: 'scheduled',
    title: 'You Have A task TODO',
    body: model['title'],
    notificationLayout: NotificationLayout.Default,),
      actionButtons: [
        NotificationActionButton(key: 'MARK_DONE', label: 'Mark Done',)
      ],
      schedule: NotificationCalendar(
        month:  notificationSchedule.date,
        weekOfMonth: notificationSchedule.date,
        hour: notificationSchedule.timeOfDay.hour,
        minute: notificationSchedule.timeOfDay.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      )
  );
}