import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/components/MyFormField.dart';
import '../../../../core/util/components/PublicButton.dart';
import '../../../../core/util/components/TimePicker.dart';
import '../../../../core/util/components/datePicker.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is AppInsertDateBaseDone) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        TaskCubit cubit = TaskCubit.get(context);
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
              'Add Task',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyFormField(
                            title: 'Title',
                            readonly: false,
                            controller: cubit.titleController,
                            type: TextInputType.text,
                            hint: 'Design Team Meeting',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            validation: (value) {
                              if (value.isEmpty) {
                                return " title can not be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //DataPicker
                          MyDatePicker(
                            controller: cubit.dateController,
                            title: "Date",
                            hint: "01 Jan,2022",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //TimePicker
                          Row(
                            children: [
                              Expanded(
                                child: MyTimePicker(
                                  controller: cubit.startTimeController,
                                  title: "Start Time",
                                  hint: '12:00 AM',
                                  hintStyle: TextStyle(color: Colors.grey[400]),

                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: MyTimePicker(

                                  controller: cubit.endTimeController,
                                  title: "End Time",
                                  hint: '12:00 PM',
                                  hintStyle: TextStyle(color: Colors.grey[400]),

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
                              hintText: 'Never',
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
                                color: Colors.grey,
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
                              cubit.selectedRemind =
                                  int.parse(value.toString());
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
                              hintText: 'None',
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
                                color: Colors.grey,
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
                            height: 1,
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
                                              TaskCubit.get(context)
                                                  .changeColor(key);
                                            },
                                            icon: Container(
                                              width: 40.0,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                // color: Colors.red,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: TaskCubit.get(context)
                                                              .selectedColor ==
                                                          key
                                                      ? Colors.green
                                                      : Colors.transparent,
                                                  width: 3.0,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(2.0),
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PublicButton(
                    backgroundColor: Colors.green,
                    function: () {
                      if (formKey.currentState!.validate()) {
                        cubit.insertDatabase(
                          title: cubit.titleController.text,
                          date: cubit.dateController.text,
                          startTime: cubit.startTimeController.text,
                          endTime: cubit.endTimeController.text,
                          reminder: cubit.selectedRemind,
                          repeat: cubit.repeatItem,
                        );
                      }
                    },
                    text: 'Create Task',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
