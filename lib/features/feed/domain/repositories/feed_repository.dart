import '../entities/post_entity.dart';

abstract class FeedRepository {
  Future<List<PostEntity>> getPosts({required int page, required int limit});
}
