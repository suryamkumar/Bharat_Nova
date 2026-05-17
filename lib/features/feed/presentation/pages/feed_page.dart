import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/feed_tab_bar.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  final ValueNotifier<bool> navVisible;
  const FeedPage({super.key, required this.navVisible});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const FeedTabBar(),
          Expanded(
            child: TabBarView(
              children: [
                _PostTab(navVisible: navVisible),
                _ComingSoonTab(label: AppStrings.nova),
                _ComingSoonTab(label: AppStrings.news),
                _ComingSoonTab(label: AppStrings.article),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostTab extends StatefulWidget {
  final ValueNotifier<bool> navVisible;
  const _PostTab({required this.navVisible});

  @override
  State<_PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<_PostTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(const FeedLoadRequested());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final dir = _scrollController.position.userScrollDirection;
    if (dir == ScrollDirection.reverse) {
      widget.navVisible.value = false;
    } else if (dir == ScrollDirection.forward) {
      widget.navVisible.value = true;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<FeedBloc>().add(const FeedLoadMoreRequested());
    }
  }

  Future<void> _onRefresh() async {
    context.read<FeedBloc>().add(const FeedRefreshRequested());
    await context.read<FeedBloc>().stream.firstWhere(
      (s) => s is FeedLoaded || s is FeedError,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return switch (state) {
          FeedInitial() || FeedLoading() => _buildShimmer(),
          FeedError() => _buildError(state.message),
          FeedLoaded() => _buildList(state.posts, state.hasMore),
          FeedLoadingMore() => _buildList(state.posts, true),
        };
      },
    );
  }

  Widget _buildList(List posts, bool hasMore) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primaryCLR,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(
          top: 8,
          bottom: kBottomNavigationBarHeight + 8,
        ),
        itemCount: posts.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryCLR,
                  strokeWidth: 2.5,
                ),
              ),
            );
          }
          return PostCard(post: posts[index]);
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.errorLoading,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<FeedBloc>().add(const FeedLoadRequested()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCLR,
                foregroundColor: AppColors.whiteCLR,
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {
  final String label;
  const _ComingSoonTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '$label — ${AppStrings.comingSoon}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
