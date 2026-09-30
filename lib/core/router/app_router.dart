import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/core/widgets/scaffold_with_nav.dart';
import 'package:rescuelink/features/auth/presentation/login_screen.dart';
import 'package:rescuelink/features/auth/presentation/providers/auth_provider.dart';
import 'package:rescuelink/features/auth/presentation/register_screen.dart';
import 'package:rescuelink/features/incidents/presentation/create_incident_screen.dart';
import 'package:rescuelink/features/incidents/presentation/incident_detail_screen.dart';
import 'package:rescuelink/features/incidents/presentation/incidents_screen.dart';
import 'package:rescuelink/features/map/presentation/map_screen.dart';
import 'package:rescuelink/features/notifications/presentation/notifications_screen.dart';
import 'package:rescuelink/features/profile/presentation/profile_screen.dart';
import 'package:rescuelink/features/incidents/presentation/dashboard_screen.dart';

Widget _build(BuildContext ctx, GoRouterState s, Widget child) => child;

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      
      // If user is not logged in, redirect to login unless on register/login screen
      if (user == null && !isAuthRoute) {
        return '/login';
      }

      // If user is logged in and tries to access auth screen, redirect to dashboard
      if (user != null && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (ctx, s) => _build(ctx, s, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        builder: (ctx, s) => _build(ctx, s, const RegisterScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (ctx, s, shell) => ScaffoldWithNav(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard',
              builder: (ctx, s) => _build(ctx, s, const DashboardScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/incidents',
              builder: (ctx, s) => _build(ctx, s, const IncidentsScreen()),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (ctx, s) =>
                      _build(ctx, s, const CreateIncidentScreen()),
                ),
                GoRoute(
                  path: ':id',
                  builder: (ctx, state) => IncidentDetailScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/map',
              builder: (ctx, s) => _build(ctx, s, const MapScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (ctx, s) => _build(ctx, s, const ProfileScreen()),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (ctx, s) => _build(ctx, s, const NotificationsScreen()),
      ),
    ],
  );
});
