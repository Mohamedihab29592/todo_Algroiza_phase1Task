import 'package:flutter/material.dart';

int createUniqueId(){
  return DateTime.now().millisecondsSinceEpoch.remainder(10000);
}

class NotificationDateAndTime{
  final int date;
  final TimeOfDay timeOfDay;

  NotificationDateAndTime({
    required this.date,
    required this.timeOfDay,
});

}
Future<NotificationDateAndTime?> pickSchedule(BuildContext context)
async {

  TimeOfDay timeOfDay = TimeOfDay.now();
  await showTimePicker(context: context, initialTime:timeOfDay);
  return null;
}