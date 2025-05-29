import 'package:get_it/get_it.dart';
import 'package:time_optimizer/data/auth/repositories/mock_auth_repository_impl.dart';
import 'package:time_optimizer/domain/auth/repositories/auth_repository.dart';
import 'package:time_optimizer/presentation/auth/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External (Data Sources, Repositories, etc.)
  // Using MockAuthRepositoryImpl temporarily to avoid Hive initialization issues
  sl.registerSingleton<AuthRepository>(MockAuthRepositoryImpl());

  // BLoCs / Cubits (should usually be registered as Factory or LazySingleton depending on use case)
  // AuthBloc is global and needed throughout the app, so LazySingleton is appropriate.
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));

  // Register other services and BLoCs here as the app grows
  // Example:
  // sl.registerLazySingleton(() => MyApiService());
  // sl.registerFactory(() => MyOtherBloc(sl()));
  // print('Service locator initialized with AuthBloc and AuthRepository.');
}
