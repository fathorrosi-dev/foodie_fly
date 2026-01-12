import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/injection.dart' as di;
import 'package:foodie_fly/main.dart';
import 'package:foodie_fly/presentation/bloc/foods_bloc/foods_bloc.dart';
import 'package:foodie_fly/presentation/pages/home_page/components/food_card.dart';
import 'package:foodie_fly/utils/helpers/helper_function.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Menu extends StatelessWidget {
  final String category;
  const Menu({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.locator<FoodsBloc>()..add(GetFoodsEvent(category)),
      child: BlocBuilder<FoodsBloc, FoodsState>(
        builder: (context, state) {
          if (state is FoodsLoading) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: HelperFunction.isDarkMode(context)
                    ? $styles.colors.darkBackground
                    : $styles.colors.lightBackground,
                size: 24,
              ),
            );
          } else if (state is FoodLoaded) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.foods.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final food = state.foods[index];
                return FoodCard(food: food);
              },
            );
          } else if (state is FoodsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
