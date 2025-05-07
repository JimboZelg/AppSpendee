import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/providers/community_provider.dart';
import 'package:spendee/comunity/widgets/login_required_dialog.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isPosting = false;

  Future<void> _submitPost() async {
    final provider = context.read<CommunityProvider>();
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    final isSignedIn = await provider.isUserSignedIn();
    if (!isSignedIn) {
      showDialog(
        context: context,
        builder: (_) => const LoginRequiredDialog(),
      );
      return;
    }

    setState(() => _isPosting = true);
    await provider.addPost(text);
    setState(() => _isPosting = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: '¿Qué deseas compartir?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isPosting ? null : _submitPost,
              icon: const Icon(Icons.send),
              label: _isPosting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}
