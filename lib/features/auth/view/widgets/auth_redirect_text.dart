import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Tappable "Don't have an account? Sign Up" style footer used by the
/// auth pages.
class AuthRedirectText extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onTap;

  const AuthRedirectText({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: promptText,
          style: Theme.of(context).textTheme.titleMedium,
          children: [
            TextSpan(
              text: ' $actionText',
              style: const TextStyle(
                color: Palette.gradient2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
