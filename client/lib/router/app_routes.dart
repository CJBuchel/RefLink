import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Type-safe navigation routes for the entire app.
///
/// Usage:
/// - Named navigation: `AppRoute.setup.go(context)`
/// - With parameters: `AppRoute.setup.go(context, queryParams: {'tab': 'database'})`
///
/// Route definitions:
/// - path: The actual path used in go_router (for route definitions)
/// - name: The route name used for named navigation
enum AppRoute {
  // Public routes
  splash(path: '/', name: 'splash'),
  headReferee(path: '/headReferee', name: 'headReferee'),
  referee(path: '/referee/:id', name: 'referee');

  const AppRoute({required this.path, required this.name});

  /// The path used in go_router route definitions
  final String path;

  /// The route name used by go_router for named navigation
  final String name;

  /// Navigate to this route using go_router's goNamed method
  void go(
    BuildContext context, {
    Map<String, String>? pathParams,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) {
    context.goNamed(
      name,
      pathParameters: pathParams ?? {},
      queryParameters: queryParams ?? {},
      extra: extra,
    );
  }

  /// Navigate to this route using go_router's pushNamed method
  Future<T?> push<T>(
    BuildContext context, {
    Map<String, String>? pathParams,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) {
    return context.pushNamed<T>(
      name,
      pathParameters: pathParams ?? {},
      queryParameters: queryParams ?? {},
      extra: extra,
    );
  }

  /// Get the current route based on the current route name
  static AppRoute? current(BuildContext context) {
    final routeName = GoRouterState.of(context).topRoute?.name;

    if (routeName == null) return null;

    for (final route in values) {
      if (routeName == route.name) {
        return route;
      }
    }

    return null;
  }
}
