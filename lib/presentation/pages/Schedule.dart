import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algroiza210/core/util/components/divider.dart';
import 'package:intl/intl.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/Schedule_Task_Item.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final DatePickerController _controller = DatePickerController();

  String now = DateFormat("EEEE").format(DateTime.now());
  String selectedValue = DateFormat("dd MMM, yyyy'").format(DateTime.now());



  @override
  Widget build(BuildContext context) {
    TaskCubit cubit = TaskCubit.get(context);
    TaskCubit.get(context).scheduleData(date: selectedValue);
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
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
                      const TextStyle(color: Colors.black),
                  onDateChange: (pickedDate) {
                    setState(() {
                      selectedValue =
                          DateFormat("dd MMM, yyyy").format(pickedDate);
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
                  child: ConditionalBuilder(
                condition: cubit.schedule
                    .where((element) => element.date == selectedValue)
                    .toList()
                    .isNotEmpty,
                builder: (context) => ListView.builder(
                  itemBuilder: (context, index) => ScheduleTaskItem(
                      task: cubit.schedule
                          .where((element) => element.date == selectedValue)
                          .toList()[index]),
                  itemCount: cubit.schedule
                      .where((element) => element.date == selectedValue)
                      .toList()
                      .length,
                ),
                fallback: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [Icon(
                    Icons.edit,
                    size: 50,
                    color: Colors.grey,
                  ),
                    Text('No Tasks on this day  ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),],
                      );
                }
              )),
            ],
          ),
        );
      },
    );
  }
}
