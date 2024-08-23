import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        path: '/home/:accessToken',
        builder: (context, state) {
          final accessToken = state.pathParameters['accessToken'] ?? '';
          return HomeScreen(accessToken: accessToken);
        },
      ),
      GoRoute(
        path: '/details/tasks',
        builder: (context, state) {
          final task = state.extra as Task?;
          if (task == null) {
            return Scaffold(
              body: Center(child: Text('No task data')),
            );
          }
          return TaskDetailScreen(task: task);
        },
      ),
    ],
  );
}
