import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetPostsUsecase {
  final FeedRepository _repository;

  GetPostsUsecase(this._repository);

  Future<List<PostEntity>> call({required int page, required int limit}) {
    return _repository.getPosts(page: page, limit: limit);
  }
}
