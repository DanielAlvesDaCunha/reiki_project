import 'package:get_it/get_it.dart';

import '../../core/network/dio_client.dart';
import '../../repositories/drawing_save_repository.dart';
import '../../repositories/drawing_save_repository_impl.dart';
import '../../repositories/symbol_repository.dart';
import '../../repositories/symbol_repository_impl.dart';
import '../../viewmodels/disclaimer/disclaimer_viewmodel.dart';
import '../../viewmodels/symbol/symbol_viewmodel.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  sl.registerLazySingleton<SymbolRepository>(() => SymbolRepositoryImpl());
  sl.registerLazySingleton<DrawingSaveRepository>(() => DrawingSaveRepositoryImpl());

  // ViewModels (BLoC)
  sl.registerFactory<DisclaimerViewModel>(() => DisclaimerViewModel());
  sl.registerFactory<SymbolViewModel>(() => SymbolViewModel(sl<SymbolRepository>()));
}
