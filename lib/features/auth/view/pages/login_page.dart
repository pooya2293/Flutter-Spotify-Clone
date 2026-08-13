import 'package:client/core/utils/navigation.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/auth_redirect_text.dart';
import 'package:client/features/auth/view/widgets/auth_scaffold.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign In.',
      formKey: formKey,
      children: [
        CustomField(hintText: 'Email', controller: emailController),
        const SizedBox(height: 30),
        CustomField(
          hintText: 'Password',
          controller: passwordController,
          isObscureText: true,
        ),
        const SizedBox(height: 20),
        AuthGradientButton(
          buttonText: 'Sign in',
          onTap: () async {
            final res = await AuthRemoteRepository().login(
              email: emailController.text,
              password: passwordController.text,
            );
            final val = switch (res) {
              Left(value: final l) => l,
              Right(value: final r) => r.email,
            };
            debugPrint('Login result: $val');
          },
        ),
        const SizedBox(height: 20),
        AuthRedirectText(
          promptText: 'Don\'t have an account? ',
          actionText: 'Sign Up',
          onTap: () => pushPage(context, const SignupPage()),
        ),
      ],
    );
  }
}
