import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/comunity/providers/community_provider.dart';
import 'package:spendee/comunity/screens/community_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  bool _isLoading = false;

  void _goToCommunity(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CommunityHomeScreen()),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final provider = context.read<CommunityProvider>();
    setState(() => _isLoading = true);
    await provider.signInWithGoogle();
    setState(() => _isLoading = false);
    _goToCommunity(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final provider = context.read<CommunityProvider>();
    setState(() => _isLoading = true);
    await provider.signInAnonymously();
    setState(() => _isLoading = false);
    _goToCommunity(context);
  }

  Future<void> _submitEmailAuth() async {
    final provider = context.read<CommunityProvider>();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        await provider.signInWithEmail(email, password);
      } else {
        await provider.signUpWithEmail(email, password);
      }
      _goToCommunity(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a la Comunidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitEmailAuth,
              child: Text(isLogin ? 'Iniciar sesión' : 'Registrarse'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? '¿No tienes cuenta? Regístrate aquí'
                  : '¿Ya tienes cuenta? Inicia sesión'),
            ),
            const Divider(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.account_circle),
              label: const Text('Iniciar sesión con Google'),
              onPressed: _isLoading ? null : () => _signInWithGoogle(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_outline),
              label: const Text('Entrar como invitado'),
              onPressed: _isLoading ? null : () => _signInAnonymously(context),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
