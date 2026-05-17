import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUsecase _getPostsUsecase;

  static const int _pageSize = 10;
  int _currentPage = 1;

  FeedBloc(this._getPostsUsecase) : super(const FeedInitial()) {
    on<FeedLoadRequested>(_onLoad);
    on<FeedLoadMoreRequested>(_onLoadMore);
    on<FeedRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    FeedLoadRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(const FeedLoading());
    _currentPage = 1;
    try {
      final posts = await _getPostsUsecase(page: 1, limit: _pageSize);
      emit(FeedLoaded(posts: posts, hasMore: posts.length == _pageSize));
    } on AppFailure catch (e) {
      emit(FeedError(e.message));
    } catch (e) {
      emit(FeedError(AppFailure.unknown(e.toString()).message));
    }
  }

  Future<void> _onLoadMore(
    FeedLoadMoreRequested event,
    Emitter<FeedState> emit,
  ) async {
    final current = state;
    if (current is! FeedLoaded || !current.hasMore) return;

    emit(FeedLoadingMore(posts: current.posts));

    try {
      _currentPage++;
      final more = await _getPostsUsecase(page: _currentPage, limit: _pageSize);
      emit(FeedLoaded(
        posts: [...current.posts, ...more],
        hasMore: more.length == _pageSize,
      ));
    } on AppFailure {
      _currentPage--;
      emit(FeedLoaded(posts: current.posts, hasMore: current.hasMore));
    } catch (_) {
      _currentPage--;
      emit(FeedLoaded(posts: current.posts, hasMore: current.hasMore));
    }
  }

  Future<void> _onRefresh(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(const FeedLoading());
    _currentPage = 1;
    try {
      final posts = await _getPostsUsecase(page: 1, limit: _pageSize);
      emit(FeedLoaded(posts: posts, hasMore: posts.length == _pageSize));
    } on AppFailure catch (e) {
      emit(FeedError(e.message));
    } catch (e) {
      emit(FeedError(AppFailure.unknown(e.toString()).message));
    }
  }
}
