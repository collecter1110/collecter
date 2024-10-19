import 'package:get_it/get_it.dart';

import '../provider/ranking_provider.dart';
import 'api_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());

  locator.registerLazySingleton(() => RankingProvider());
}
