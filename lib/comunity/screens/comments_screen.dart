import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/models/comment.dart';
import 'package:spendee/comunity/providers/community_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    await context.read<CommunityProvider>().fetchComments(widget.postId);
    setState(() => _isLoading = false);
  }

  void _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para comentar')),
      );
      return;
    }

    final comment = Comment(
      id: '',
      postId: widget.postId,
      content: text,
      authorId: user.uid,
      authorName: user.displayName ?? 'Anónimo',
      timestamp: Timestamp.now(),
    );

    await context.read<CommunityProvider>().addComment(comment);
    _controller.clear();
    await _loadComments(); // Refresca la lista después de agregar
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<CommunityProvider>().comments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        title: Text(comment.authorName),
                        subtitle: Text(comment.content),
                        trailing: Text(
                          '${comment.timestamp.toDate().hour}:${comment.timestamp.toDate().minute}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
