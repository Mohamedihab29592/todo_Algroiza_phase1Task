import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/components/MyCheckBox.dart';
import '../cubit/cubit.dart';



Widget buildTaskitem(Map model, context) => Dismissible(
    key: Key(model['id'].toString()),
    child: Row(
      children: [
        MyCheckBox(
          myColor: model['colorPriority'] == 0
              ? Colors.blue
              : model['colorPriority'] == 1
                  ? Colors.orange
                  : Colors.red,
        ),
        Text(
          '${model['title']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: const Text("Completed"),
                    onTap: () {
                      TaskCubit.get(context)
                          .updateData(status: 'completed', id: model['id']);
                    },
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: const Text("unCompleted"),
                    onTap: () {
                      TaskCubit.get(context)
                          .updateData(status: 'unCompleted', id: model['id']);
                    },
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: const Text("Favorite"),
                    onTap: () {
                      TaskCubit.get(context)
                          .updateData(status: 'Favorite', id: model['id']);
                    },
                  )
                ]),
      ],
    ),
    onDismissed: (direction) {
      if (direction == DismissDirection.startToEnd) {
        TaskCubit.get(context).deleteData(
          id: model['id'],
        );
      } else {
        TaskCubit.get(context).deleteData(
          id: model['id'],
        );
      }
    });

Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => buildTaskitem(tasks[index], context),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.edit,
              size: 50,
              color: Colors.grey,
            ),
            Text('No Tasks PLease add some Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );

Widget scheduleTaskItem(Map model, context) => Padding(
      padding: const EdgeInsets.only(top: 10,right: 25,left: 25,bottom: 10),
      child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: model['colorPriority'] == 0
                ? Colors.blue
                : model['colorPriority'] == 1
                    ? Colors.orange
                    : Colors.red,
            borderRadius: BorderRadius.circular(20),

          ),

          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '${model['starTime']}\n',
                    children: <TextSpan>[
                      TextSpan(
                          text: '${model['title']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
               const Spacer(),
                if(model['status']=='completed')
                  const Icon(Icons.check_circle_outlined,size: 20,color: Colors.white,),
                if(model['status']=='new'||model['status']=='unCompleted'||model['status']=='Favorite')
                const Icon(Icons.circle_outlined,size: 20,color: Colors.white,),




              ],
            ),
          )
      ),
    );

Widget scheduleTaskBuilder({required schedule }) => ConditionalBuilder(
      condition: schedule.isNotEmpty,
      builder: (context) => ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              scheduleTaskItem(schedule[index], context),
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
              ),
          itemCount: schedule.length),
      fallback: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.edit,
            size: 50,
            color: Colors.grey,
          ),
          Text('No Tasks PLease add some Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
