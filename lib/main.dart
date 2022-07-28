import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/tasks/presentation/cubit/cubit.dart';
import 'features/tasks/presentation/pages/layout/board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notifications with on Time  functionality',
        defaultColor: Color(0xFF9D50DD),
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        criticalAlerts: true,
        channelShowBadge: true,
      ),

      NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
        defaultColor: Color(0xFF9D50DD),
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
        criticalAlerts: true,
        channelShowBadge: true,
      ),

    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
            create: (context) => TaskCubit()..iniDatabase()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const BoardPage(),
      ),
    );
  }
}
