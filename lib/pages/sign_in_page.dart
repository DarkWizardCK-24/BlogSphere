import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/pages/home_page.dart';
import 'package:bloggg_app/pages/sign_up_page.dart';
import 'package:bloggg_app/services/auth_service.dart';
import 'package:bloggg_app/widgets/auth_field.dart';
import 'package:bloggg_app/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (formKey.currentState!.validate()) {
      try {
        final session = await _authService.signIn(
          emailController.text,
          passwordController.text,
        );
        if (session != null) {
          Navigator.pushReplacement(context, HomePage.route());
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e'), backgroundColor: AppPallete.errorColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                  vertical: constraints.maxHeight * 0.02,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 600 : constraints.maxWidth,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In.',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        AuthField(
                          hinttext: "Email",
                          controller: emailController,
                          isObscureText: false,
                          prefixIcon: Icon(Icons.email, color: AppPallete.greyColor),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
                        AuthField(
                          hinttext: "Password",
                          controller: passwordController,
                          isObscureText: true,
                          prefixIcon: Icon(Icons.lock, color: AppPallete.greyColor),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        AuthGradientButton(
                          buttonText: 'Sign In',
                          onPressed: _handleSignIn,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, SignUpPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppPallete.gradient5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}