import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/components/custom_sliver_app_bar.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/app_drawer.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/current_location.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/custom_tab_bar.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/description_box.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/menu.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          context.go('/');
        }
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CustomSliverAppBar(
              title: CustomTabBar(tabController: tabController),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: HelperFunction.isDarkMode(context)
                        ? $styles.colors.darkDivider
                        : $styles.colors.lightDivider,
                    thickness: 1,
                  ),
                  const CurrentLocation(),
                  const DescriptionBox(),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: tabController,
            children: const [
              Menu(category: 'burger'),
              Menu(category: 'salad'),
              Menu(category: 'sides'),
              Menu(category: 'dessert'),
              Menu(category: 'drinks'),
            ],
          ),
        ),
      ),
    );
  }
}
