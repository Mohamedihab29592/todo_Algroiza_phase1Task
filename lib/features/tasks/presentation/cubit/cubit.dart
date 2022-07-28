import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:todo_algroiza210/features/tasks/presentation/cubit/states.dart';
import '../pages/all_Tasks.dart';
import '../pages/complted_Tasks.dart';
import '../pages/favorite.dart';
import '../pages/unCompleted.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskCubitInitialState());

  static TaskCubit get(context) => BlocProvider.of(context);

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
  List<Map> allTasks = [];
  List<Map> completeTasks = [];
  List<Map> unCompleteTasks = [];
  List<Map> favouriteTasks = [];
  List<Map> scheduleDate = [];

  String selectedRemind = '1 day before';
  int selectedColor = 0;
  String repeatItem = 'none';
  List<String> remindList = [
    '1 day before',
    '1 hour before',
    '30 before',
    '10 min before',
  ];
  List<String> repeatList = ['none', 'Daily', 'weekly', 'Monthly'];

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
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title STRING , date STRING , starTime STRING, endTime STRING , reminder STRING,repeat STRING, colorPriority INTEGER , status STRING)',
      );
      debugPrint("Database created");
    }, onOpen: (Database db) {
      debugPrint("Database open");
      database = db;
      getTasksData();
    });
  }

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();

  void insertDatabase({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required String reminder,
    required String repeat,
    required int colorPriority,
  }) async {
    database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO tasks(title,date,starTime,endTime,reminder,repeat,colorPriority,status) VALUES("$title","$date","$startTime","$endTime","$selectedRemind","$repeatItem","$selectedColor","new")',
      )
          .then((value) {
        getTasksData();
        titleController.clear();
        dateController.clear();
        startTimeController.clear();
        endTimeController.clear();
        debugPrint('$value inserted done');

        emit(AppInsertDateBaseDone());
      }).catchError((error) {
        debugPrint('Error when Inserting New record ${error.toString()}');
      });
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    // Update some record
    await database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getTasksData();
      emit(UpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getTasksData();
      emit(AppDeleteDataBase());
    });
  }

  void scheduleData({required String date}) async {
    await database
        .rawQuery('SELECT * FROM tasks WHERE date = ?', [date]).then((value) {
      scheduleDate = value;
    });

    emit(ScheduleDataBase());
  }

  void getTasksData() async {
    allTasks = [];
    completeTasks = [];
    unCompleteTasks = [];
    favouriteTasks = [];
    scheduleDate = [];

    emit(AppLoadingState());
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          allTasks.add(element);
        } else if (element['status'] == 'completed') {
          completeTasks.add(element);
          emit(CompleteTasksState());
        } else if (element['status'] == 'unCompleted') {
          unCompleteTasks.add(element);
          emit(NoncompleteTasksState());
        } else if (element['status'] == 'Favorite') {
          favouriteTasks.add(element);

          emit(FavouriteTasksState());
        }
        scheduleDate.add(element);
      }

      emit(AppDataBaseTasks());
    });
  }
}
