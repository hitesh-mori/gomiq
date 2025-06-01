import 'package:flutter/material.dart' ;
import 'package:gomiq/pages/auth_pages/login_register.dart';

import 'helper_functions/router.dart';


late Size mq ;


void main(){
  runApp(MyApp()) ;
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
      routerConfig: router,
    );
  }
}
