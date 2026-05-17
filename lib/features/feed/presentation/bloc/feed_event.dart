sealed class FeedEvent {
  const FeedEvent();
}

final class FeedLoadRequested extends FeedEvent {
  const FeedLoadRequested();
}

final class FeedLoadMoreRequested extends FeedEvent {
  const FeedLoadMoreRequested();
}

final class FeedRefreshRequested extends FeedEvent {
  const FeedRefreshRequested();
}
