import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algroiza210/core/util/components/divider.dart';
import 'package:intl/intl.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/taskItem.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final DatePickerController _controller = DatePickerController();
  String now = DateFormat("EEEE").format(DateTime.now());
  String selectedValue = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {},
      builder: (context, state) {
        var schedule = TaskCubit.get(context).scheduleDate;
        TaskCubit.get(context).scheduleData(date: selectedValue);
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
              'Schedule',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              const MyDivider(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: DatePicker(
                  DateTime.now(),
                  width: 60,
                  height: 80,
                  controller: _controller,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.green,
                  selectedTextColor: Colors.white,
                  dateTextStyle: const TextStyle(color: Colors.black),
                  monthTextStyle:
                      const TextStyle(color: Colors.transparent, fontSize: 0),
                  onDateChange: (pickedDate) {
                    setState(() {
                      selectedValue =
                          DateFormat("yyyy-MM-dd").format(pickedDate);
                      now = DateFormat("EEEE").format(pickedDate);
                    });
                  },
                ),
              ),
              const MyDivider(),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Text(
                      now,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      selectedValue,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: scheduleTaskBuilder(
                schedule: schedule,
              )),
            ],
          ),
        );
      },
    );
  }
}
