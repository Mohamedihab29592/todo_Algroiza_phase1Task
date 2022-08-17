
class TaskModel {
  final int id;
   String title;
     String  date;
  final String startTime;
  final String endTime;
  final int reminder;
  final int repeat;
   int colorPriority;
  final int completed;
  final int favorite;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.repeat,
    required this.colorPriority,
    required this.completed,
    required this.favorite,
  }

  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      reminder: json['reminder'] as int,
      repeat: json['repeat'] as int,
      colorPriority: json['colorPriority'] as int,
      completed: json['completed'] as int,
      favorite: json['favorite'] as int,
    );

  }
}