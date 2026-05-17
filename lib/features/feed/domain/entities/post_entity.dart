class PostEntity {
  final int id;
  final String title;
  final String body;
  final String authorName;
  final String authorAvatar;
  final bool isVerified;
  final List<String> imageUrls;
  final String location;
  final DateTime publishedAt;
  final int likesCount;
  final int commentsCount;
  final int repostCount;
  final int seenCount;
  final int bookmarkCount;

  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.authorAvatar,
    required this.isVerified,
    required this.imageUrls,
    required this.location,
    required this.publishedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.repostCount,
    required this.seenCount,
    required this.bookmarkCount,
  });
}
