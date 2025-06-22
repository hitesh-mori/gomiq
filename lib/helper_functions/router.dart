import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomiq/pages/auth_pages/login_register.dart';
import 'package:gomiq/pages/home_pages/chat_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/chat',
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

Page<void> _noAnimationPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: Duration.zero,
  );
}