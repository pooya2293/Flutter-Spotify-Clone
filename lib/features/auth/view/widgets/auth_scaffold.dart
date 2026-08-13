import 'package:client/core/widgets/loader.dart';
import 'package:flutter/material.dart';

/// Shared layout for the auth pages: an app bar, a centered form and a
/// large page title, with an optional loading state.
class AuthScaffold extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final bool isLoading;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.children,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...children,
                  ],
                ),
              ),
            ),
    );
  }
}
