import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hocflutter/src/Api/provider/api_service.dart';
import 'package:hocflutter/src/feature/bottapScreens/home/logic/task_logic.dart';
import 'package:hocflutter/src/feature/router/router.dart';
import 'package:hocflutter/src/feature/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAiyzU-BowmQpSVtbQtMUCRPYiGLUCWhW0',
        appId: '1:273987515815:web:5a5eac8f55b7a678b97282',
        messagingSenderId: '273987515815',
        projectId: 'nppersonnel-c2968'),
    name: 'nppersonnel-c2968',
  );
  await initializeDateFormatting('vi_VN', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) =>TaskLogic()),
        
        ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
