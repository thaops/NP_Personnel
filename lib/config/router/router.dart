import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/config/router/main_bottap.dart';
import 'package:hocflutter/screens/bottapScreens/add_screen.dart';
import 'package:hocflutter/screens/bottapScreens/notifications_screen.dart';
import 'package:hocflutter/screens/bottapScreens/profile_screen.dart';
import 'package:hocflutter/screens/bottapScreens/search_screen.dart';
import 'package:hocflutter/screens/home_screen.dart';
import 'package:hocflutter/screens/login_screen.dart';
import 'package:hocflutter/screens/task_detail_screen.dart';
import 'package:hocflutter/Api/models/task.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
        GoRoute(
        path: '/main',
        builder: (context, state) => MainScreen(),
      ),

      GoRoute(
        path: '/details/tasks',
        builder: (context, state) {
          final task = state.extra as Task?;
          if (task == null) {
            return Scaffold(
              body: const Center(child: Text('No task data')),
            );
          }
          return TaskDetailScreen(task: task);
        },
      ),
    ],
  );
}
