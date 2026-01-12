import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/domain/entities/cart_item_entity.dart';
import 'package:foodie_fly/domain/entities/food_entity.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/components/navbar.dart';
import 'package:foodie_fly/presentation/pages/cart_page/cart_page.dart';
import 'package:foodie_fly/presentation/pages/checkout_page/checkout_page.dart';
import 'package:foodie_fly/presentation/pages/delivery_progress_page/delivery_progress_page.dart';
import 'package:foodie_fly/presentation/pages/food_detail_page/food_detail_page.dart';
import 'package:foodie_fly/presentation/pages/login_page/login_page.dart';
import 'package:foodie_fly/presentation/pages/order_page/order_page.dart';
import 'package:foodie_fly/presentation/pages/register_page.dart/register_page.dart';
import 'package:go_router/go_router.dart';
import 'package:foodie_fly/presentation/components/app_scaffold.dart';
import 'package:foodie_fly/presentation/pages/home_page/home_page.dart';
import 'package:foodie_fly/injection.dart' as di;

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      final isAuthenticated = authState is Authenticated;
      final isAuthenticating = authState is AuthLoading;
      final isLoginPage = state.matchedLocation == '/';
      final isRegisterPage = state.matchedLocation == '/register';

      if (isAuthenticating) return null;

      if ((isLoginPage || isRegisterPage) && isAuthenticated) {
        return '/navbar';
      }

      if (!isAuthenticated && !isLoginPage && !isRegisterPage) return '/';

      return null;
    },
    refreshListenable: GoRouterRefreshStream(di.locator<AuthBloc>().stream),
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: LoginPage())),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: RegisterPage())),
      ),
      GoRoute(
        path: '/navbar',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: Navbar())),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: HomePage())),
      ),
      GoRoute(
        path: '/food_detail_page',
        pageBuilder: (context, state) {
          FoodEntity food = state.extra as FoodEntity;
          return MaterialPage(
            child: AppScaffold(child: FoodDetailPage(food: food)),
          );
        },
      ),
      GoRoute(
        path: '/cart',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: CartPage())),
      ),
      GoRoute(
        path: '/order',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AppScaffold(child: OrderPage())),
      ),
      GoRoute(
        path: '/checkout',
        pageBuilder: (context, state) {
          List<CartItemEntity> cartItems = state.extra as List<CartItemEntity>;
          return MaterialPage(
            child: AppScaffold(child: CheckoutPage(cartItems: cartItems)),
          );
        },
      ),
      GoRoute(
        path: '/delivery',
        pageBuilder: (context, state) {
          List<CartItemEntity> cartItems = state.extra as List<CartItemEntity>;
          return MaterialPage(
            child: AppScaffold(
              child: DeliveryProgressPage(cartItems: cartItems),
            ),
          );
        },
      ),
    ],
  );
}

final router = buildRouter();
