import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hocflutter/src/feature/router/main_bottap.dart';


import 'package:hocflutter/src/Api/models/task_model.dart';
import 'package:hocflutter/src/feature/login/login_screen.dart';
import 'package:hocflutter/src/feature/update_task/task_update_screen.dart';

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
