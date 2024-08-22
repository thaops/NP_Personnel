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
//         path: '/home',
//         builder: (context, state) => HomeScreen(),
//       ),
//       GoRoute(
//         path: '/details/:id',
//         builder: (context, state) {
//           // Lấy id từ state
//           final taskId = state.params['id']!;
//           final task = _findTaskById(taskId);
//           return TaskDetailScreen(task: task);
//         },
//       ),
//     ],
//   );

//   Task? _findTaskById(String id) {
//     // Thực hiện tìm kiếm task dựa trên id
//     // Ví dụ, nếu bạn có danh sách tasks, bạn có thể tìm kiếm như sau:
//     // return tasks.firstWhere((task) => task.id == id, orElse: () => null);
//     return null; // Thay đổi thành logic tìm kiếm task thực tế
//   }
// }
