import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return const Scaffold();
      },
    ),
  ],
);
