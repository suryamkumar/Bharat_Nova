import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getPosts({required int page, required int limit});
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient _apiClient;

  FeedRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  }) async {
    final skip = (page - 1) * limit;
    final response = await _apiClient.get(
      AppEndpoints.posts,
      queryParameters: {'limit': limit, 'skip': skip},
    ) as Map<String, dynamic>;

    final posts = response['posts'] as List<dynamic>;
    return posts.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
