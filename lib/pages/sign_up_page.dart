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

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
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
            SnackBar(
              content: const Text('Check your email for confirmation'),
              backgroundColor: AppPallete.gradient5,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: $e'),
            backgroundColor: AppPallete.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPallete.borderColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppPallete.gradient5.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppPallete.whiteColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppPallete.backgroundColor,
                      AppPallete.backgroundColor.withOpacity(0.9),
                      AppPallete.gradient3.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Floating circles
                    Positioned(
                      top: 120 + (_floatingAnimation.value * 25),
                      right: 40,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient3.withOpacity(0.1),
                          border: Border.all(
                            color: AppPallete.gradient3.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100 - (_floatingAnimation.value * 20),
                      left: 20,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient4.withOpacity(0.1),
                          border: Border.all(
                            color: AppPallete.gradient4.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 250 - (_floatingAnimation.value * 15),
                      left: 60,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient1.withOpacity(0.15),
                          border: Border.all(
                            color: AppPallete.gradient1.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 300 + (_floatingAnimation.value * 10),
                      right: 80,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient2.withOpacity(0.12),
                          border: Border.all(
                            color: AppPallete.gradient2.withOpacity(0.35),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.08,
                  vertical: screenSize.height * 0.02,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 500 : double.infinity,
                    minHeight: screenSize.height * 0.8,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo/Icon section
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppPallete.gradient3,
                                      AppPallete.gradient4,
                                      AppPallete.gradient1,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPallete.gradient3.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 60,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.04),

                            // Welcome text
                            Column(
                              children: [
                                Text(
                                  'Join Us Today!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: isLargeScreen ? 36 : 32,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: AppPallete.gradient3
                                                .withOpacity(0.5),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Create your account and start blogging',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: isLargeScreen ? 16 : 14,
                                        color: AppPallete.greyColor.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.05),

                            // Form fields
                            AuthField(
                              hinttext: "Enter your full name",
                              controller: nameController,
                              isObscureText: false,
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppPallete.gradient1,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.025),
                            AuthField(
                              hinttext: "Enter your email",
                              controller: emailController,
                              isObscureText: false,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: AppPallete.gradient5,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.025),
                            AuthField(
                              hinttext: "Create a strong password",
                              controller: passwordController,
                              isObscureText: true,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppPallete.gradient4,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),

                            // Terms and conditions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppPallete.borderColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppPallete.gradient3.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'By signing up, you agree to our Terms of Service and Privacy Policy',
                                style: TextStyle(
                                  color: AppPallete.greyColor.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.03),

                            // Sign up button
                            AuthGradientButton(
                              buttonText: 'Create Account',
                              onPressed: _handleSignUp,
                              isLoading: _isLoading,
                              icon: Icons.person_add,
                            ),
                            SizedBox(height: screenSize.height * 0.04),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppPallete.greyColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: AppPallete.greyColor.withOpacity(
                                        0.7,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppPallete.greyColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenSize.height * 0.03),

                            // Sign in link
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppPallete.borderColor.withOpacity(
                                    0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppPallete.gradient3.withOpacity(
                                      0.2,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, SignInPage.route());
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Already have an account?\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Sign In Here',
                                          style: TextStyle(
                                            color: AppPallete.gradient3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppPallete.gradient3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
