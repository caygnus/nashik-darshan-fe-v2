import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/pages/bottom_bar_page.dart';
import 'package:nashik/core/pages/deep_link_handler_page.dart';
import 'package:nashik/core/supabase/config.dart';
import 'package:nashik/features/auth/presentation/pages/login_page.dart';
import 'package:nashik/features/auth/presentation/pages/oauth_callback_page.dart';
import 'package:nashik/features/auth/presentation/pages/signup_page.dart';
import 'package:nashik/features/auth/presentation/pages/splash_screen.dart';
import 'package:nashik/features/category/presentation/pages/category_page.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/iternary/presentation/pages/iternary_page.dart';
import 'package:nashik/features/profile/presentation/pages/profile_page.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';

class RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRouteChange('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRouteChange('REPLACE', newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRouteChange('REMOVE', route, previousRoute);
  }

  void _logRouteChange(
    String action,
    Route<dynamic>? currentRoute,
    Route<dynamic>? previousRoute,
  ) {
    final currentName = currentRoute?.settings.name ?? 'Unknown';
    final previousName = previousRoute?.settings.name ?? 'None';
    final currentPath = _getRoutePath(currentRoute);
    final previousPath = _getRoutePath(previousRoute);

    developer.log(
      'Route $action: $previousName ($previousPath) → $currentName ($currentPath)',
      name: 'Router',
    );
  }

  String _getRoutePath(Route<dynamic>? route) {
    if (route?.settings.arguments is Map) {
      final args = route!.settings.arguments as Map;
      if (args.containsKey('uri')) {
        return args['uri'].toString();
      }
    }
    return route?.settings.name ?? route?.toString() ?? 'Unknown';
  }
}

class Approuter {
  static final Approuter _instance = Approuter.init();

  static final instance = _instance;
  static late final GoRouter router;
  static final RouteObserver _routeObserver = RouteObserver();

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> categoryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> itineraryTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  Approuter.init() {
    final List<RouteBase> routes = <RouteBase>[
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        pageBuilder: (context, state, navigationShell) => getPage(
          child: BottomBarPage(shell: navigationShell),
          state: state,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: HomeScreen.routePath,
                name: HomeScreen.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const HomeScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: categoryTabNavigatorKey,
            routes: [
              GoRoute(
                path: CategoryPage.routePath,
                name: CategoryPage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const CategoryPage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: itineraryTabNavigatorKey,
            routes: [
              GoRoute(
                path: IternaryPage.routePath,
                name: IternaryPage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const IternaryPage(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                pageBuilder: (context, state) =>
                    getPage(child: const ProfilePage(), state: state),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: StreetFoodScreen.routePath,
        name: StreetFoodScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const StreetFoodScreen(), state: state),
      ),
      GoRoute(
        path: TransportScreen.routePath,
        name: TransportScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const TransportScreen(), state: state),
      ),
      GoRoute(
        path: HotelsScreen.routePath,
        name: HotelsScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const HotelsScreen(), state: state),
      ),
      GoRoute(
        path: EateryScreen.routePath,
        name: EateryScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const EateryScreen(), state: state),
      ),
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const SplashScreen(), state: state),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const LoginPage(), state: state),
      ),
      GoRoute(
        path: SignupPage.routePath,
        name: SignupPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const SignupPage(), state: state),
      ),
      GoRoute(
        path: OAuthCallbackPage.routePath,
        name: OAuthCallbackPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const OAuthCallbackPage(), state: state),
      ),
      GoRoute(
        path: DeepLinkHandlerPage.routePath,
        name: DeepLinkHandlerPage.routeName,
        pageBuilder: (context, state) =>
            getPage(child: const DeepLinkHandlerPage(), state: state),
      ),
      GoRoute(
        path: '/:path(.*)',
        pageBuilder: (context, state) {
          return getPage(child: const HomeScreen(), state: state);
        },
      ),
    ];
    router = GoRouter(
      initialLocation: HomeScreen.routePath,
      navigatorKey: parentNavigatorKey,
      routes: routes,
      redirect: handleRedirect,
      observers: [_routeObserver],
      debugLogDiagnostics: true,
    );

    _setupRouteChangeLogging();
  }
  static Page getPage({required Widget child, required GoRouterState state}) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
      name: state.uri.toString(),
      arguments: {'uri': state.uri},
    );
  }

  static void _setupRouteChangeLogging() {
    router.routerDelegate.addListener(() {
      try {
        final location = router.location;
        developer.log('Route changed to: $location', name: 'Router');
      } catch (e) {
        // Ignore errors during route change logging
      }
    });
  }
}

extension GoRouterExtension on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  Stream<String> get locationStream =>
      Stream<String>.periodic(const Duration(seconds: 1), (computationCount) {
        return Approuter.router.location;
      });
}

final List<String> protectedRoutes = [ProfilePage.routePath];

String? handleRedirect(BuildContext context, GoRouterState state) {
  final uri = state.uri;
  final path = uri.path;
  final fullUri = uri.toString();

  developer.log('Redirect check: $fullUri (path: $path)', name: 'Router');

  if (uri.scheme == 'com.caygnus.nashikdarshan') {
    final handlerUri = Uri(
      path: DeepLinkHandlerPage.routePath,
      queryParameters: {'deep_link': uri.toString()},
    );
    developer.log(
      'Redirect: Deep link → ${handlerUri.toString()}',
      name: 'Router',
    );
    return handlerUri.toString();
  }

  final user = SupabaseConfig.client.auth.currentUser;

  if (user == null && protectedRoutes.contains(path)) {
    developer.log(
      'Redirect: Protected route without auth → ${LoginPage.routePath}',
      name: 'Router',
    );
    return LoginPage.routePath;
  }

  return null;
}
