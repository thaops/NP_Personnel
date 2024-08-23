// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hocflutter/screens/home_screen.dart';
// import 'package:hocflutter/screens/login_screen.dart';
// import 'package:hocflutter/screens/task_detail_screen.dart';
// import 'package:hocflutter/Api/models/task.dart';

// class AppRouter {
//   final GoRouter router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/login',
//         builder: (context, state) => LoginScreen(),
//       ),
//       GoRoute(
//         path: '/home/:accessToken',
//         builder: (context, state) {
//           final accessToken = state.queryParameters['accessToken'] ?? '';
//           return HomeScreen(accessToken: accessToken);
//         },
//       ),
//       GoRoute(
//         path: '/details/:id',
//         builder: (context, state) {
//           final id = state.pathParameters['id']!;
//           final task = _findTaskById(id); // Thay thế bằng logic tìm task thực tế
//           return TaskDetailScreen(task: task!);
//         },
//       ),
//     ],
//   );

//   Task? _findTaskById(String id) {
//     // Thực hiện tìm kiếm task dựa trên id
//     return null; // Thay đổi thành logic tìm kiếm task thực tế
//   }
// }
