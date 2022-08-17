
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algroiza210/core/util/components/divider.dart';
import 'package:todo_algroiza210/data/model/task_model.dart';
import '../../../../../core/util/components/PublicButton.dart';
import '../../../../../core/util/components/constats.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../Schedule.dart';
import '../add_TaskScreen.dart';
import '../all_Tasks.dart';
import '../complted_Tasks.dart';
import '../favorite.dart';
import '../unCompleted.dart';

class BoardPage extends StatefulWidget {
   const BoardPage({Key? key, }) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}


class _BoardPageState extends State<BoardPage> {
   TaskModel? taskModel;




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Board',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(onPressed: () {
                    navigateTo(context, const Schedule());

                    }, icon: const Icon(Icons.calendar_today)),

                ],
              ),
              body: Column(
                children: [
                  const MyDivider(),
                  const TabBar(
                    labelPadding: EdgeInsets.all(7),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Completed'),
                      Tab(text: 'unCompleted'),
                      Tab(text: 'Favorite'),
                    ],
                  ),

                  const MyDivider(),
                  //TabBarView
                  const Expanded(
                    child: TabBarView(
                      children: [
                        AllTasks(),
                        CompletedTasks(),
                        UnCompleted(),
                        Favourite(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: PublicButton(
                          backgroundColor: Colors.green,
                          function: () {
                            navigateTo(context, const AddTask());
                          },
                          text: 'Add Task',
                        )),
                  ),
                ],
              )
          ),
        );
      },

    );
  }

}
