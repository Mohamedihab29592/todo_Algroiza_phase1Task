import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../widgets/taskItem.dart';

class UnCompleted extends StatefulWidget {
  const UnCompleted({Key? key}) : super(key: key);

  @override
  State<UnCompleted> createState() => _UnCompletedState();
}

class _UnCompletedState extends State<UnCompleted> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {},
      builder: (context, state) {
        var unCompleteTasks =TaskCubit.get(context).unCompleteTasks;
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: taskBuilder(tasks: unCompleteTasks)
              ),

            ],
          ),
        );
      },);
  }
}
