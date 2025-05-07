import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/providers/community_provider.dart';
import 'package:spendee/comunity/screens/comments_screen.dart';
import 'package:spendee/comunity/screens/create_post_screen.dart';
import 'package:intl/intl.dart';

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final posts = provider.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CommunityProvider>().fetchPosts(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
        },
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text('No hay publicaciones aún.'))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(post.timestamp.toDate());

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(post.authorName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.content),
                            const SizedBox(height: 8),
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up, size: 20),
                              onPressed: () => context.read<CommunityProvider>().likePost(post.id),
                            ),
                            Text('${post.likes}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentsScreen(postId: post.id),
                            ),
                          );
                        },
                        onLongPress: () => context.read<CommunityProvider>().dislikePost(post.id),
                      ),
                    );
                  },
                ),
    );
  }
}
