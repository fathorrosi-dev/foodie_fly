import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:lottie/lottie.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: HelperFunction.screenWidth(context) - 77,
      backgroundColor: HelperFunction.isDarkMode(context)
          ? $styles.colors.darkSurface
          : $styles.colors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(70),
                child: Lottie.asset(
                  HelperFunction.isDarkMode(context)
                      ? 'assets/animations/truck.json'
                      : 'assets/animations/truck2.json',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: HelperFunction.isDarkMode(context)
                        ? $styles.colors.lightBackground
                        : $styles.colors.darkBackground,
                  ),
                  title: Text(
                    'H O M E',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.info,
                    color: HelperFunction.isDarkMode(context)
                        ? $styles.colors.lightBackground
                        : $styles.colors.darkBackground,
                  ),
                  title: Text(
                    'A B O U T',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: GestureDetector(
              onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: HelperFunction.isDarkMode(context)
                      ? $styles.colors.lightBackground
                      : $styles.colors.darkBackground,
                ),
                title: Text(
                  'L O G O U T',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
