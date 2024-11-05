import 'package:get_it/get_it.dart';

import '../provider/collection_provider.dart';
import '../provider/page_route_provider.dart';
import '../provider/ranking_provider.dart';
import '../provider/search_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => RankingProvider());

  locator.registerLazySingleton(() => CollectionProvider());

  locator.registerLazySingleton(() => SearchProvider());

  locator.registerLazySingleton(() => PageRouteProvider());
}
