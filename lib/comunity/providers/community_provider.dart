import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class CommunityProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();

  List<Post> _posts = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    if (_posts.isNotEmpty) return; // evita lecturas innecesarias

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      _posts = snapshot.docs
          .map((doc) => Post.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPost(String content) async {
    try {
      final user = await _authService.getCurrentUser();

      final post = Post(
        id: '',
        content: content,
        authorId: user.id,
        authorName: user.name,
        likes: 0,
        dislikes: 0,
        commentCount: 0,
        timestamp: Timestamp.now(),
      );

      final docRef = await _firestore.collection('posts').add(post.toMap());
      final newPost = post.copyWith(id: docRef.id);
      _posts.insert(0, newPost);

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding post: $e');
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _firebaseService.incrementCounter(
        collection: 'posts',
        docId: postId,
        field: 'likes',
      );
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(likes: _posts[index].likes + 1);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error liking post: $e');
    }
  }

  Future<void> dislikePost(String postId) async {
    try {
      await _firebaseService.incrementCounter(
        collection: 'posts',
        docId: postId,
        field: 'dislikes',
      );
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] =
            _posts[index].copyWith(dislikes: _posts[index].dislikes + 1);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error disliking post: $e');
    }
  }

  Future<void> addComment(Comment comment) async {
  try {
    final postRef = _firestore.collection('posts').doc(comment.postId);
    final commentRef = await postRef.collection('comments').add(comment.toMap());
    final newComment = comment.copyWith(id: commentRef.id);

    _comments.insert(0, newComment);
    await _firebaseService.incrementCounter(
      collection: 'posts',
      docId: comment.postId,
      field: 'commentCount',
    );

    notifyListeners();
  } catch (e) {
    debugPrint('Error adding comment: $e');
  }
}

  Future<void> fetchComments(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      _comments = snapshot.docs
          .map((doc) => Comment.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching comments: $e');
    }
  }

  // 🔐 Autenticación
  Future<bool> isUserSignedIn() async => _authService.isSignedIn();
  User? get currentUser => _authService.currentUser;
  Future<CommunityUser> getCurrentUser() => _authService.getCurrentUser();

  Future<void> signInAnonymously() async {
    await _authService.signInAnonymously();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password);
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _authService.signUpWithEmail(email, password);
    notifyListeners();
  }
}
