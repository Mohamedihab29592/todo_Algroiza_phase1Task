import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:todo_algroiza210/presentation/cubit/states.dart';

import '../../core/util/services/notification_handler/notifications_service.dart';
import '../../data/model/reminder_model.dart';
import '../../data/model/repeat_model.dart';
import '../../data/model/task_model.dart';
import '../pages/all_Tasks.dart';
import '../pages/complted_Tasks.dart';
import '../pages/favorite.dart';
import '../pages/unCompleted.dart';
import 'package:intl/intl.dart';


class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskCubitInitialState());

  static TaskCubit get(context) => BlocProvider.of(context);
  NotifyHelper notificationService = NotifyHelper();


  int currentIndex = 0;
  List<Widget> screens = const [
    AllTasks(),
    CompletedTasks(),
    UnCompleted(),
    Favourite(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeTabBarState());
  }

  late Database database;
  List<TaskModel> allTasks = [];
  List<TaskModel> schedule = [];

  int selectedRemind = 0;

  List<ReminderModel> reminderList = [
    ReminderModel(
      minutes: 0,
      reminder: 'Never',
    ),
    ReminderModel(
      minutes: 10,
      reminder: '10 minutes before',
    ),
    ReminderModel(
      minutes: 30,
      reminder: '30 minutes before',
    ),
    ReminderModel(
      minutes: 60,
      reminder: '1 hour before',
    ),
  ];
  int repeatItem = 0;
  List<RepeatModel> repeatList = [
    RepeatModel(
      hours: 0,
      repeat: 'none',
    ),
    RepeatModel(
      hours: 24,
      repeat: 'Daily',
    ),
    RepeatModel(
      hours: 168,
      repeat: 'Weekly',
    ),
    RepeatModel(
      hours: 720,
      repeat: 'Monthly',
    ),
  ];

  int selectedColor = 0;
  List<MaterialColor> taskColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  void changeColor(index) {
    selectedColor = index;
    emit(TaskColorChanged());
  }

  //List<String> repeatList = ['none', 'Daily', 'weekly', 'Monthly'];

  void iniDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'tasks.db');
    emit(TaskDatabaseInitialized());

    openDataBase(
      path: path,
    );

    emit(TaskDatabaseInitialized());
  }

  void openDataBase({required String path}) async {
    openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY,'
            ' title TEXT, date TEXT, startTime TEXT,'
            ' endTime TEXT,'
            ' reminder INTEGER,'
            ' repeat INTEGER,'
            ' colorPriority INTEGER,'
            ' completed INTEGER,'
            ' favorite INTEGER)',
      );
      debugPrint("Database created");
    }, onOpen: (Database db) {
      debugPrint("Database open");
      database = db;
      getTasksData();
    });
  }

  late TaskModel taskModel;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();

  void insertDatabase({

    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required int reminder,
    required int repeat,
  }) async {
   await  database.transaction((txn) async {
      emit(AppLoadingInsertDataBaseState());
      await txn
          .rawInsert(
        'INSERT INTO tasks(title,date,startTime,endTime,reminder,repeat,colorPriority,completed, favorite) VALUES("$title","$date","$startTime","$endTime","$selectedRemind ","$repeatItem","$selectedColor",0,0)',
      )
          .then((value) async {
        getTasksData();
        selectedRemind = 0;
        repeatItem = 0;
        titleController.clear();
        dateController.clear();
        startTimeController.clear();
        endTimeController.clear();
        DateTime date = DateFormat.jm()
            .parse(startTime.toString())
            .subtract(Duration(minutes: repeatItem));
        var myTime = DateFormat('HH:mm').format(date);
        await notificationService
            .scheduledNotification(
          title: title,
          time: startTime,
          repeat: repeat,
          reminder: reminder,
          hour: int.parse(myTime.toString().split(':')[0]),
          minute: int.parse(myTime.toString().split(':')[1]),
        );
        emit(AppInsertDateBaseDone());
      }).catchError((error) {
        debugPrint('Error when Inserting New record ${error.toString()}');
      });
    });
  }

  void updateTask({
    required int id,
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required int reminder,
    required int repeat,
    required int color,
  }) async {
   await database.transaction((txn) async {
      await txn
          .rawInsert(
        'UPDATE tasks SET title = ?,date = ?,startTime = ?,endTime = ?,reminder = ?,repeat = ?,colorPriority = ? WHERE id = $id',
        [title,date,startTime,endTime,reminder,repeat,color]
      ).then((value) async{
        selectedRemind = 0;
        repeatItem = 0;
        titleController.clear();
        dateController.clear();
        startTimeController.clear();
        endTimeController.clear();
        DateTime date = DateFormat.jm()
            .parse(startTime.toString())
            .subtract(Duration(minutes: repeatItem));
        var myTime = DateFormat('HH:mm').format(date);
        await notificationService
            .scheduledNotification(
          title: title,
          time: startTime,
          repeat: repeat,
          reminder: reminder,
          hour: int.parse(myTime.toString().split(':')[0]),
          minute: int.parse(myTime.toString().split(':')[1]),
        );
        getTasksData();
        emit(UpdateDatabaseState());
      });
    });
  }

  void selectTaskToUpdate({
    required TaskModel task,
  }) {
    titleController.text = task.title ;
    dateController.text = task.date;
    startTimeController.text = task.startTime;
    endTimeController.text = task.endTime;
    selectedRemind = task.reminder;
    repeatItem = task.repeat;

    emit(AppSelectTask());
  }

  void updateCompleteTask(int taskId) async {
    int completed =
    allTasks
        .firstWhere((element) => element.id == taskId)
        .completed == 1
        ? 0
        : 1;

    database.rawUpdate('UPDATE tasks SET completed = ? WHERE id = $taskId',
        [completed]).then((value) {
      debugPrint('Task Data Updated');
      getTasksData();
    });
  }

  void updateFavoriteTask(int taskId) async {
    int favorite =
    allTasks
        .firstWhere((element) => element.id == taskId)
        .favorite == 1
        ? 0
        : 1;

    database.rawUpdate('UPDATE tasks SET favorite = ? WHERE id = $taskId',
        [favorite]).then((value) {
      debugPrint('Task Data Updated');
      getTasksData();
    });
  }

  void deleteData({
    required int id,
  }) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      notificationService.cancelNotifications(id);
      getTasksData();
      emit(AppDeleteDataBase());
    });
  }

  void scheduleData({required String date}) async {
    emit(AppLoadingState());
    await database
        .rawQuery('SELECT * FROM tasks WHERE date = ?', [date]).then((value) {
      {
        schedule = [];
        for (var element in value) {
          schedule.add(TaskModel.fromJson(element));
        }
        emit(ScheduleDataBase());
      }
    });
  }

  void getTasksData() async {
    emit(AppLoadingState());
    allTasks = [];
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      debugPrint('Tasks Data Fetched');
      debugPrint(value.toString());
      for (var element in value) {
        allTasks.add(TaskModel.fromJson(element));
      }
      emit(AppDataBaseTasks());
    });
  }




}
