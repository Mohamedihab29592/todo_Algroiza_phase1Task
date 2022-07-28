import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_algroiza210/core/util/components/divider.dart';
import '../../../../../core/util/components/PublicButton.dart';
import '../../../../../core/util/components/constats.dart';
import '../../../../../core/util/notification_handler/notifications_service.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../Schedule.dart';
import '../add_TaskScreen.dart';
import '../all_Tasks.dart';
import '../complted_Tasks.dart';
import '../favorite.dart';
import '../unCompleted.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}


class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) =>
    {
      if(!isAllowed)
        {
          showDialog(context: context, builder: (context) =>
              AlertDialog(
                title: const Text('Allow Notifications'),
                content: const Text('our app would like to send notifications'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      child: Text('Don\'t allow',
                        style: TextStyle(fontSize: 18, color: Colors.grey),)),
                  TextButton(onPressed: () =>
                      AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) => Navigator.pop(context)),
                    child: const Text('Allow', style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),),)
                ],

              ))
        }
    });

    AwesomeNotifications().actionStream.listen((notification) {
      if(notification.channelKey == 'basic_channel'&& Platform.isIOS)
        {
          AwesomeNotifications().getGlobalBadgeCounter().then((value) =>AwesomeNotifications().setGlobalBadgeCounter(value -1));

        }
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => Schedule()), (
          route) => route.isFirst);
    });
  }

  @override
  void disose()
  {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {},
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('Swipe to delete',
                          style: TextStyle(fontSize: 10, color: Colors.red),),
                      ],
                    ),
                  ),
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
