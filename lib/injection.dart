import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie_fly/data/data_source/local/user_session_manager.dart';
import 'package:foodie_fly/data/data_source/remote/remote_data_source.dart';
import 'package:foodie_fly/data/repositories/auth_repository_impl.dart';
import 'package:foodie_fly/data/repositories/repository_impl.dart';
import 'package:foodie_fly/domain/repository/auth_repository.dart';
import 'package:foodie_fly/domain/repository/repository.dart';
import 'package:foodie_fly/domain/usecases/add_to_cart.dart';
import 'package:foodie_fly/domain/usecases/get_addons.dart';
import 'package:foodie_fly/domain/usecases/get_cart_items.dart';
import 'package:foodie_fly/domain/usecases/get_foods.dart';
import 'package:foodie_fly/domain/usecases/remove_from_cart.dart';
import 'package:foodie_fly/domain/usecases/update_cart_item.dart';
import 'package:foodie_fly/presentation/bloc/addons_bloc/addons_bloc.dart';
import 'package:foodie_fly/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:foodie_fly/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:foodie_fly/presentation/bloc/foods_bloc/foods_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> init() async {
  // Firebase
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth,
      firebaseFirestore,
      sharedPreferences,
      locator(),
    ),
  );

  locator.registerLazySingleton<Repository>(
    () => RepositoryImpl(locator(), locator()),
  );

  // Datasource
  locator.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(firebaseFirestore),
  );
  locator.registerLazySingleton<UserSessionManager>(
    () => UserSessionManagerImpl(firebaseAuth, sharedPreferences),
  );

  // Usecases
  locator.registerLazySingleton(() => GetFoods(locator()));
  locator.registerLazySingleton(() => GetAddons(locator()));
  locator.registerLazySingleton(() => GetCartItems(locator()));
  locator.registerLazySingleton(() => AddToCart(locator()));
  locator.registerLazySingleton(() => UpdateCartItem(locator()));
  locator.registerLazySingleton(() => RemoveFromCart(locator()));

  // Bloc
  locator.registerFactory(() => AuthBloc(locator()));
  locator.registerFactory(() => FoodsBloc(locator()));
  locator.registerFactory(() => AddonsBloc(locator()));
  locator.registerFactory(
    () => CartBloc(
      Object(),
      getCartItems: locator<GetCartItems>(),
      addToCart: locator<AddToCart>(),
      updateCartItem: locator<UpdateCartItem>(),
      removeFromCart: locator<RemoveFromCart>(),
    ),
  );
}
