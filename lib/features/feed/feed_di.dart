import '../../core/di/injection.dart';
import 'data/datasources/feed_remote_datasource.dart';
import 'data/repositories/feed_repository_impl.dart';
import 'domain/repositories/feed_repository.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'presentation/bloc/feed_bloc.dart';

Future<void> initFeedDependency() async {
  sl.registerLazySingleton<FeedRemoteDataSource>(() => FeedRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<FeedRepository>(() => FeedRepositoryImpl(sl()));

  sl.registerLazySingleton<GetPostsUsecase>(() => GetPostsUsecase(sl()));

  sl.registerFactory<FeedBloc>(() => FeedBloc(sl()));
}
