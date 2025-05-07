import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final int likes;
  final int dislikes;
  final int commentCount;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.likes,
    required this.dislikes,
    required this.commentCount,
    required this.timestamp,
  });

  factory Post.fromMap(Map<String, dynamic> data, String documentId) {
    return Post(
      id: documentId,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'likes': likes,
      'dislikes': dislikes,
      'commentCount': commentCount,
      'timestamp': timestamp,
    };
  }

  Post copyWith({
    String? id,
    String? content,
    String? authorId,
    String? authorName,
    int? likes,
    int? dislikes,
    int? commentCount,
    Timestamp? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      commentCount: commentCount ?? this.commentCount,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
