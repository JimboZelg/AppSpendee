import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String content;
  final String authorId;
  final String authorName;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> data, String documentId) {
    return Comment(
      id: documentId,
      postId: data['postId'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'timestamp': timestamp,
    };
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? content,
    String? authorId,
    String? authorName,
    Timestamp? timestamp,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
