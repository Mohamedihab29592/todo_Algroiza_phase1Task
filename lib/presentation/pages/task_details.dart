import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algroiza210/core/util/components/MyFormField.dart';
import 'package:todo_algroiza210/core/util/components/constats.dart';
import 'package:todo_algroiza210/data/model/task_model.dart';
import 'package:todo_algroiza210/presentation/cubit/cubit.dart';
import 'package:todo_algroiza210/presentation/cubit/states.dart';
import 'package:todo_algroiza210/presentation/pages/layout/board.dart';

import '../../core/util/components/TimePicker.dart';
import '../../core/util/components/datePicker.dart';
import '../../data/model/reminder_model.dart';
import '../../data/model/repeat_model.dart';

class TaskDetails extends StatefulWidget {
  final TaskModel tasks;
   ReminderModel? reminderModel;
   RepeatModel? repeatModel;

  TaskDetails({Key? key, required this.tasks, this.repeatModel, this.reminderModel}) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  String reminder = "";

  String repeat = "";

  MaterialColor? color;

  int updateColor= 0;

  @override
  Widget build(BuildContext context) {
    if (widget.tasks.reminder == 0) {
      reminder = 'Never';
    } else if (widget.tasks.reminder == 10) {
      reminder = ' 10 minutes before ';
    } else if (widget.tasks.reminder == 30) {
      reminder = ' 30 minutes before ';
    } else {
      reminder = "1 hour before";
    }

    if (widget.tasks.repeat == 0) {
      repeat = 'None';
    } else if (widget.tasks.repeat == 24) {
      repeat = ' Daily ';
    } else if (widget.tasks.repeat == 168) {
      repeat = ' weekly ';
    } else {
      repeat = "Monthly";
    }



    TaskCubit cubit = TaskCubit.get(context);
    return BlocConsumer<TaskCubit,TaskState>(
      listener: (context,state){
        if(state is UpdateDatabaseState)
          {
            navigateTo(context, const BoardPage());
          }

      },
      builder: (context ,state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                )),
            title: const Text(
              'Task Details',
              style: TextStyle(
                  fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  cubit.updateTask(
                    id: widget.tasks.id,
                      title: cubit.titleController.text,
                      date: cubit.dateController.text,
                      startTime: cubit.startTimeController.text,
                      endTime: cubit.endTimeController.text,
                      reminder: cubit.selectedRemind,
                      repeat: cubit.repeatItem,
                      color: widget.tasks.colorPriority);
                },
                child: const Text('Update'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyFormField(
                    title: 'Task Title',
                    type: TextInputType.text,
                    hint: widget.tasks.title,
                    readonly: false,
                    controller: cubit.titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyDatePicker(
                    controller: cubit.dateController,
                    title: "Date",
                    hint: widget.tasks.date,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTimePicker(
                          controller: cubit.startTimeController,
                          title: "Start Time",
                          hint: widget.tasks.startTime,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: MyTimePicker(
                          controller: cubit.endTimeController,
                          title: "End Time",
                          hint: widget.tasks.endTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Reminder",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: reminder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    items: cubit.reminderList
                        .asMap()
                        .map(
                          (key, value) => MapEntry(
                        key,
                        DropdownMenuItem(
                          value: value.minutes,
                          child: Text(
                            value.reminder,
                          ),
                        ),
                      ),
                    )
                        .values
                        .toList(),
                    onChanged: (value) {
                      cubit.selectedRemind = int.parse(value.toString());
                      debugPrint('$value');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Repeat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: repeat,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    items: cubit.repeatList
                        .asMap()
                        .map(
                          (key, value) => MapEntry(
                        key,
                        DropdownMenuItem(
                          value: value.hours,
                          child: Text(
                            value.repeat,
                          ),
                        ),
                      ),
                    )
                        .values
                        .toList(),
                    onChanged: (value) {
                      cubit.repeatItem = int.parse(value.toString());
                      debugPrint('$value');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Color Priority',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          ...TaskCubit.get(context)
                              .taskColors
                              .asMap()
                              .map(
                                (key, value) => MapEntry(
                              key,
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    updateColor=key;
                                    widget.tasks.colorPriority=updateColor;
                                  });

                                },
                                icon: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: widget.tasks.colorPriority == key
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 3.0,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: value,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                              .values
                              .toList(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
