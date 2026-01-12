import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/presentation/bloc/addons_bloc/addons_bloc.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:foodie_fly/presentation/bloc/foods_bloc/foods_bloc.dart';
import 'package:foodie_fly/presentation/components/app_scaffold.dart';
import 'package:foodie_fly/presentation/theme/app_style.dart';
import 'package:foodie_fly/utils/router.dart';
import 'package:foodie_fly/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.locator<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (context) => di.locator<FoodsBloc>()),
        BlocProvider(create: (context) => di.locator<AddonsBloc>()),
        BlocProvider(
          create: (context) =>
              di.locator<CartBloc>()..add(const LoadCartItems()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: $styles.toThemeData(),
        darkTheme: $styles.toThemeData(isDark: true),
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}

AppStyle get $styles => AppScaffold.style;
