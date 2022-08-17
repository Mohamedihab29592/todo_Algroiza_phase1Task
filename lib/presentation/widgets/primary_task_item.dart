import 'package:flutter/material.dart';
import 'package:todo_algroiza210/core/util/components/constats.dart';
import 'package:todo_algroiza210/presentation/pages/task_details.dart';

import '../../data/model/task_model.dart';
import '../cubit/cubit.dart';

class PrimaryTaskItem extends StatelessWidget {
  final TaskModel task;

  const PrimaryTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navigateTo(context, TaskDetails(tasks: task,));
        TaskCubit.get(context).selectTaskToUpdate(task: task);
      },

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                TaskCubit.get(context).updateCompleteTask(task.id);
              },
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: task.completed == 1
                      ? TaskCubit.get(context).taskColors[task.colorPriority]
                      : null,
                  border: Border.all(
                    color:
                        TaskCubit.get(context).taskColors[task.colorPriority],
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: task.completed == 1
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18.0,
                      )
                    : Container(),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child:Icon(
                      task.favorite == 1
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: Colors.red,
                    ),
                    onTap: () {
                      TaskCubit.get(context).updateFavoriteTask(task.id);

                    },
                  ),
                  PopupMenuItem(
                    value: 2,
                    child:const Icon(Icons.delete),
                    onTap: () {
                      TaskCubit.get(context).deleteData(
                          id:task.id);
                    },
                  ),

                ]),
          ],
        ),
      ),
        );



  }
}






