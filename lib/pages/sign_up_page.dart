import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/pages/home_page.dart';
import 'package:bloggg_app/pages/sign_in_page.dart';
import 'package:bloggg_app/services/auth_service.dart';
import 'package:bloggg_app/widgets/auth_field.dart';
import 'package:bloggg_app/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (formKey.currentState!.validate()) {
      try {
        final response = await _authService.signUp(
          nameController.text,
          emailController.text,
          passwordController.text,
        );
        if (response.session != null) {
          Navigator.pushReplacement(context, HomePage.route());
        } else {
          Navigator.pushReplacement(context, SignInPage.route());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check your email for confirmation')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed: $e'), backgroundColor: AppPallete.errorColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.transparentColor,
      ),
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
                          'Sign Up.',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        AuthField(
                          hinttext: "Name",
                          controller: nameController,
                          isObscureText: false,
                          prefixIcon: Icon(Icons.person, color: AppPallete.greyColor),
                        ),
                        SizedBox(height: screenSize.height * 0.015),
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
                          buttonText: 'Sign Up',
                          onPressed: _handleSignUp,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, SignInPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign In',
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