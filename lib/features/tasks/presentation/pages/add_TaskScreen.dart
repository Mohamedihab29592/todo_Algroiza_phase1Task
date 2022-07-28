import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/components/MyFormField.dart';
import '../../../../core/util/components/PublicButton.dart';
import '../../../../core/util/components/TimePicker.dart';
import '../../../../core/util/components/datePicker.dart';
import '../../../../core/util/notification_handler/notifications_service.dart';
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
          onTimeNotification();
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
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: MyTimePicker(
                                    controller: cubit.endTimeController,
                                    title: "End Time",
                                    hint: '12:00 PM'),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          MyFormField(
                            title: 'Remind',
                            readonly: true,
                            type: TextInputType.text,
                            hint: cubit.selectedRemind,
                            widget: DropdownButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  cubit.selectedRemind = newValue!;
                                });
                              },
                              items: cubit.remindList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          MyFormField(
                            title: 'Repeat',
                            readonly: true,
                            type: TextInputType.text,
                            hint: cubit.repeatItem,
                            widget: DropdownButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  cubit.repeatItem = newValue!;
                                });
                              },
                              items: cubit.repeatList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Wrap(
                                  children:
                                      List<Widget>.generate(3, (int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          cubit.selectedColor = index;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: index == 0
                                                ? Colors.blue
                                                : index == 1
                                                    ? Colors.orange
                                                    : Colors.red,
                                            child: cubit.selectedColor == index
                                                ? const Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                    size: 16,
                                                  )
                                                : Container()),
                                      ),
                                    );
                                  }),
                                ),
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
                          colorPriority: cubit.selectedColor,
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
