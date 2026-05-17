import '../../domain/entities/post_entity.dart';

sealed class FeedState {
  const FeedState();
}

final class FeedInitial extends FeedState {
  const FeedInitial();
}

final class FeedLoading extends FeedState {
  const FeedLoading();
}

final class FeedLoaded extends FeedState {
  final List<PostEntity> posts;
  final bool hasMore;

  const FeedLoaded({required this.posts, required this.hasMore});
}

final class FeedLoadingMore extends FeedState {
  final List<PostEntity> posts;

  const FeedLoadingMore({required this.posts});
}

final class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);
}
