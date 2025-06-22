import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomiq/main.dart';
import 'package:gomiq/pages/auth_pages/login_register.dart';
import 'package:gomiq/pages/home_pages/chat_screen.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(BuildContext context) {

  final userProvider = Provider.of<UserProvider>(context, listen: false);

  userProvider.isLogged() ;

  bool isLoggedIn = userProvider.currUserId!=null ;

  print("Log in check in router : $isLoggedIn") ;

  return GoRouter(

    initialLocation: isLoggedIn ? '/chat' : '/',

    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _noAnimationPage(
          LoginRegister(),
        ),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => _noAnimationPage(
          ChatScreen(),
        ),
      ),
    ],
  );
}

Page<void> _noAnimationPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    transitionDuration: Duration.zero,
  );
}
