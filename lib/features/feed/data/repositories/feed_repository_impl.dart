import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;

  FeedRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PostEntity>> getPosts({
    required int page,
    required int limit,
  }) {
    return _remoteDataSource.getPosts(page: page, limit: limit);
  }
}
