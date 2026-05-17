import 'dart:math';
import '../../domain/entities/post_entity.dart';

const _indianCities = [
  'Delhi',
  'Mumbai',
  'Hyderabad',
  'Bengaluru',
  'Chennai',
  'Kolkata',
  'Pune',
  'Ahmedabad',
  'Jaipur',
  'Lucknow',
  'Patna',
  'Bhopal',
  'Bhubaneswar',
  'Chandigarh',
  'Kochi',
];

const _authorNames = [
  'Naveen Joshi',
  'Priya Sharma',
  'Rahul Mehta',
  'Anjali Singh',
  'Vikram Patel',
  'Sunita Rao',
  'Arun Kumar',
  'Deepika Nair',
  'Suresh Reddy',
  'Kavitha Menon',
];

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.authorName,
    required super.authorAvatar,
    required super.isVerified,
    required super.imageUrls,
    required super.location,
    required super.publishedAt,
    required super.likesCount,
    required super.commentsCount,
    required super.repostCount,
    required super.seenCount,
    required super.bookmarkCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final userId = json['userId'] as int;
    final rng = Random(id);

    final reactions = json['reactions'] as Map<String, dynamic>?;
    final likes = reactions?['likes'] as int? ?? rng.nextInt(4900) + 100;

    final imageCount = rng.nextInt(3) + 1;

    return PostModel(
      id: id,
      title: _capitalize(json['title'] as String),
      body: json['body'] as String,
      authorName: _authorNames[(userId - 1) % _authorNames.length],
      authorAvatar: 'https://i.pravatar.cc/150?img=${(userId % 70) + 1}',
      isVerified: id % 3 != 0,
      imageUrls: List.generate(
        imageCount,
        (i) => 'https://picsum.photos/seed/${id + i * 47}/600/350',
      ),
      location: _indianCities[id % _indianCities.length],
      publishedAt: DateTime.now().subtract(Duration(hours: rng.nextInt(72) + 1)),
      likesCount: likes,
      commentsCount: rng.nextInt(195) + 5,
      repostCount: rng.nextInt(490) + 10,
      seenCount: rng.nextInt(9900) + 100,
      bookmarkCount: rng.nextInt(290) + 10,
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
