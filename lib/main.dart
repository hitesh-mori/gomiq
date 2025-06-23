import 'package:flutter/material.dart' ;
import 'package:gomiq/pages/auth_pages/login_register.dart';
import 'package:gomiq/provider/chat_provider.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'helper_functions/router.dart';


late Size mq ;


void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context)=>UserProvider()),
            ChangeNotifierProvider(create: (context)=>ChatProvider()),

          ],
          child: MyApp()
      )
  );

}

class MyApp extends StatefulWidget {


  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GomIQ',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: createRouter(context),
    );
  }
}
