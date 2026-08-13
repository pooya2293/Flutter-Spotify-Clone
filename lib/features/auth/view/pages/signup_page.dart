import 'package:client/core/utils/navigation.dart';
import 'package:client/core/utils/show_snack_bar.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/auth_redirect_text.dart';
import 'package:client/features/auth/view/widgets/auth_scaffold.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, 'User created successfully');
          pushPage(context, const LogInPage());
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return AuthScaffold(
      title: 'Sign Up.',
      formKey: formKey,
      isLoading: isLoading,
      children: [
        CustomField(hintText: 'Name', controller: nameController),
        const SizedBox(height: 30),
        CustomField(hintText: 'Email', controller: emailController),
        const SizedBox(height: 30),
        CustomField(
          hintText: 'Password',
          controller: passwordController,
          isObscureText: true,
        ),
        const SizedBox(height: 20),
        AuthGradientButton(
          buttonText: 'Sign up',
          onTap: () async {
            if (formKey.currentState!.validate()) {
              await ref
                  .read(authViewModelProvider.notifier)
                  .signUpUser(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
            }
          },
        ),
        const SizedBox(height: 20),
        AuthRedirectText(
          promptText: 'Already have an account? ',
          actionText: 'Sign In',
          onTap: () => pushPage(context, const LogInPage()),
        ),
      ],
    );
  }
}
