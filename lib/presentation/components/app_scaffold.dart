import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/components/loading_overlay_controller.dart';
import 'package:foodie_fly/presentation/theme/app_style.dart';
import 'package:foodie_fly/presentation/theme/components/app_scroll_behavior.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, this.withSafeArea = true});

  final Widget child;
  final bool withSafeArea;
  static AppStyle get style => _style;
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    _style = AppStyle(screenSize: MediaQuery.of(context).size);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          LoadingOverlayController.show(context);
        } else {
          LoadingOverlayController.hide();
        }

        if (state is SessionTimeout) {
          LoadingOverlayController.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please login again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: KeyedSubtree(
        key: ValueKey(_style.scale),
        child: Theme(
          data: _style.toThemeData(
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          child: DefaultTextStyle(
            style: _style.text.bodyMedium,
            child: ScrollConfiguration(
              behavior: AppScrollBehavior(),
              child: withSafeArea ? SafeArea(child: child) : child,
            ),
          ),
        ),
      ),
    );
  }
}
