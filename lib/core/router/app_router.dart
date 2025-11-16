import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/core/pages/bottom_bar_page.dart';
import 'package:nashik/features/category/presentation/pages/category_page.dart';
import 'package:nashik/features/eatery/presentation/pages/eatery_screen.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';
import 'package:nashik/features/hotels/presentation/pages/hotels_screen.dart';
import 'package:nashik/features/iternary/presentation/pages/iternary_page.dart';
import 'package:nashik/features/profile/presentation/pages/profile_page.dart';
import 'package:nashik/features/street_food/presentation/pages/street_food_screen.dart';
import 'package:nashik/features/transport/presentation/pages/transport_screen.dart';

class Approuter {
  static final Approuter _instance = Approuter.init();

  static final instance = _instance;
  static late final GoRouter router;

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
                routes: [
                  GoRoute(
                    path: 'street-food',
                    name: StreetFoodScreen.routeName,
                    pageBuilder: (context, state) =>
                        getPage(child: const StreetFoodScreen(), state: state),
                  ),
                  GoRoute(
                    path: 'transport',
                    name: TransportScreen.routeName,
                    pageBuilder: (context, state) =>
                        getPage(child: const TransportScreen(), state: state),
                  ),
                  GoRoute(
                    path: 'hotels',
                    name: HotelsScreen.routeName,
                    pageBuilder: (context, state) =>
                        getPage(child: const HotelsScreen(), state: state),
                  ),
                  GoRoute(
                    path: 'eatery',
                    name: EateryScreen.routeName,
                    pageBuilder: (context, state) =>
                        getPage(child: const EateryScreen(), state: state),
                  ),
                ],
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
    ];
    router = GoRouter(
      initialLocation: HomeScreen.routePath,
      navigatorKey: parentNavigatorKey,
      routes: routes,
    );
  }
  static Page getPage({required Widget child, required GoRouterState state}) {
    return MaterialPage(key: state.pageKey, child: child);
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
