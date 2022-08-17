import 'package:flutter/material.dart';
import 'package:todo_algroiza210/core/util/components/constats.dart';

import '../../data/model/task_model.dart';
import '../cubit/cubit.dart';
import '../pages/task_details.dart';

class ScheduleTaskItem extends StatelessWidget {
  final TaskModel task;

  const ScheduleTaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, TaskDetails(tasks: task,));
        TaskCubit.get(context).selectTaskToUpdate(task: task);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
        child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: TaskCubit.get(context).taskColors[task.colorPriority],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${task.startTime}\n',
                      children: <TextSpan>[
                        TextSpan(
                            text: task.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (task.completed == 1)
                    const Icon(
                      Icons.check_circle_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  if (task.completed == 0)
                    const Icon(
                      Icons.circle_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
