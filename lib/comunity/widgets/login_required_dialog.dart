import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/providers/community_provider.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final community = context.read<CommunityProvider>();

    return AlertDialog(
      title: const Text('Iniciar sesión requerido'),
      content: const Text('Debes iniciar sesión para usar esta función.'),
      actions: [
        TextButton(
          onPressed: () async {
            await community.signInAnonymously();
            Navigator.pop(context);
          },
          child: const Text('Iniciar como invitado'),
        ),
        TextButton(
          onPressed: () async {
            await community.signInWithGoogle();
            Navigator.pop(context);
          },
          child: const Text('Iniciar con Google'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
