import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.loop_rounded, size: 16, color: AppColors.textSecondary),
              SizedBox(width: 2),
              Text(
                'You Reposted',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _PostHeader(post: post),
          _PostContent(post: post),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _PostImage(imageUrls: post.imageUrls),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: _PostActionBar(post: post),
                  ),
                ],
          )),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostEntity post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: post.authorAvatar,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 50,
              height: 50,
              color: AppColors.shimmerBase,
            ),
            errorWidget: (_, __, ___) => Container(
              width: 50,
              height: 50,
              color: AppColors.shimmerBase,
              child: const Icon(
                Icons.person,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.isVerified) ...[
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 9,
                      backgroundColor: AppColors.primaryCLR,
                      child: Icon(
                        Icons.person_add_alt,
                        size: 12,
                        color: AppColors.divider,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.alternate_email_rounded,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  Flexible(
                    child: Text(
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_pin,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  Flexible(
                    child: Text(
                      '${post.location}, India',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          _timeAgo(post.publishedAt),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m';
    return 'Now';
  }
}

class _PostContent extends StatefulWidget {
  final PostEntity post;
  const _PostContent({required this.post});

  @override
  State<_PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<_PostContent> {
  final _expanded = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _expanded,
      builder: (_, expanded, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (expanded)
              Text(
                widget.post.body,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              )
            else
              GestureDetector(
                onTap: () => _expanded.value = true,
                child: const Text(
                  AppStrings.readMore,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.readMore,
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class _PostImage extends StatefulWidget {
  final List<String> imageUrls;
  const _PostImage({required this.imageUrls});

  @override
  State<_PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<_PostImage> {
  final _currentIndex = ValueNotifier<int>(0);
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    if (widget.imageUrls.length == 1) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
        child: _buildImage(widget.imageUrls.first),
      );
    }

    return Column(
      children: [
        Container(
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (i) => _currentIndex.value = i,
                itemBuilder: (_, i) => _buildImage(widget.imageUrls[i]),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentIndex,
                  builder: (_, index, __) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${index + 1}/${widget.imageUrls.length}',
                      style: const TextStyle(
                        color: AppColors.whiteCLR,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (_, index, __) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == i ? 16 : 6,
                height: 4,
                decoration: BoxDecoration(
                  color: index == i
                      ? AppColors.primaryCLR
                      : AppColors.blueGrey.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: 200,
        width: double.infinity,
        color: AppColors.shimmerBase,
      ),
      errorWidget: (_, __, ___) => Container(
        height: 200,
        width: double.infinity,
        color: AppColors.shimmerBase,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textSecondary,
          size: 40,
        ),
      ),
    );
  }
}

class _PostActionBar extends StatelessWidget {
  final PostEntity post;
  const _PostActionBar({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionItem(
            icon: Icons.favorite_border_rounded,
            label: _formatCount(post.likesCount),
          ),
          _ActionItem(
            icon: Icons.chat_bubble_outline,
            label: _formatCount(post.commentsCount),
          ),
          _ActionItem(
            icon: Icons.loop_rounded,
            label: _formatCount(post.repostCount),
          ),
          _ActionItem(
            icon: Icons.remove_red_eye_outlined,
            label: _formatCount(post.seenCount),
          ),
          _ActionItem(
            icon: Icons.bookmark_outline_rounded,
            label: _formatCount(post.bookmarkCount),
          ),
          const _ActionItem(
            icon: Icons.share_outlined,
            label: 'Share',
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.actionIcon),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
