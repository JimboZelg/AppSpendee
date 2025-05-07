import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/models/post.dart';
import 'package:spendee/comunity/providers/community_provider.dart';
import 'package:spendee/comunity/screens/comments_screen.dart';
import 'package:spendee/comunity/widgets/login_required_dialog.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CommunityProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Autor y fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${post.timestamp.toDate().day}/${post.timestamp.toDate().month}/${post.timestamp.toDate().year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Contenido
            Text(post.content),

            const SizedBox(height: 12),

            // Reacciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Like
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () async {
                    if (!await provider.isUserSignedIn()) {
                      showDialog(
                        context: context,
                        builder: (_) => const LoginRequiredDialog(),
                      );
                      return;
                    }
                    await provider.likePost(post.id);
                  },
                ),
                Text('${post.likes}'),

                // Dislike
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  onPressed: () async {
                    if (!await provider.isUserSignedIn()) {
                      showDialog(
                        context: context,
                        builder: (_) => const LoginRequiredDialog(),
                      );
                      return;
                    }
                    await provider.dislikePost(post.id);
                  },
                ),
                Text('${post.dislikes}'),

                // Comentarios
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentsScreen(postId: post.id),
                      ),
                    );
                  },
                ),
                Text('${post.commentCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
