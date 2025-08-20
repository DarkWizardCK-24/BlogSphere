import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/services/blog_service.dart';
import 'package:bloggg_app/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class CreateBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateBlogPage());
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> 
    with TickerProviderStateMixin {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final BlogService _blogService = BlogService();
  
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  
  bool _isLoading = false;
  int _wordCount = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));
    
    _animationController.forward();
    _floatingController.repeat(reverse: true);
    
    // Add listener for word count
    contentController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final words = contentController.text.trim().split(RegExp(r'\s+'));
    setState(() {
      _wordCount = contentController.text.trim().isEmpty ? 0 : words.length;
    });
  }

  Future<void> _handleCreateBlog() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _blogService.createBlog(
          titleController.text,
          contentController.text,
        );
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: AppPallete.whiteColor),
                const SizedBox(width: 12),
                Text('Blog published successfully!'),
              ],
            ),
            backgroundColor: AppPallete.gradient1,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: AppPallete.whiteColor),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to create blog: $e')),
              ],
            ),
            backgroundColor: AppPallete.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppPallete.backgroundColor,
                      AppPallete.backgroundColor.withOpacity(0.9),
                      AppPallete.gradient1.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Floating elements
                    Positioned(
                      top: 150 + (_floatingAnimation.value * 30),
                      right: 30,
                      child: Container(
                        width: 80,
                        height: 80,
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
                      bottom: 200 - (_floatingAnimation.value * 20),
                      left: 50,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient5.withOpacity(0.1),
                          border: Border.all(
                            color: AppPallete.gradient5.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 300 - (_floatingAnimation.value * 15),
                      left: 100,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPallete.gradient2.withOpacity(0.15),
                          border: Border.all(
                            color: AppPallete.gradient2.withOpacity(0.4),
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
          CustomScrollView(
            slivers: [
              // Enhanced App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: AppPallete.backgroundColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppPallete.gradient1.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppPallete.whiteColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppPallete.gradient1, AppPallete.gradient3],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.create, color: AppPallete.whiteColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Create Blog',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [AppPallete.gradient1, AppPallete.gradient3],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppPallete.backgroundColor,
                          AppPallete.gradient1.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  // Word count indicator
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppPallete.borderColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppPallete.gradient1.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$_wordCount words',
                      style: TextStyle(
                        color: AppPallete.gradient1,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Form content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                    vertical: screenSize.height * 0.02,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLargeScreen ? 800 : double.infinity,
                    ),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Inspiration text
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppPallete.gradient1.withOpacity(0.1),
                                      AppPallete.gradient3.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppPallete.gradient1.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: AppPallete.gradient1,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Share Your Story',
                                      style: TextStyle(
                                        color: AppPallete.whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Every great blog starts with a single idea. What\'s yours today?',
                                      style: TextStyle(
                                        color: AppPallete.greyColor.withOpacity(0.9),
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.03),
                              
                              // Title field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPallete.gradient1.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter an engaging title...',
                                    hintStyle: TextStyle(
                                      color: AppPallete.greyColor.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppPallete.borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppPallete.gradient1,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppPallete.borderColor.withOpacity(0.3),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppPallete.gradient1.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.title, color: AppPallete.gradient1, size: 20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Title is required' : null,
                                  style: TextStyle(
                                    color: AppPallete.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.025),
                              
                              // Content field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPallete.gradient3.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: contentController,
                                  decoration: InputDecoration(
                                    hintText: 'Start writing your amazing content here...\n\nTip: Be authentic, tell your story, and engage your readers!',
                                    hintStyle: TextStyle(
                                      color: AppPallete.greyColor.withOpacity(0.7),
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppPallete.borderColor,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppPallete.gradient3,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppPallete.borderColor.withOpacity(0.3),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppPallete.gradient3.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.edit_note, color: AppPallete.gradient3, size: 20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  ),
                                  maxLines: isLargeScreen ? 18 : 12,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Content is required' : null,
                                  style: TextStyle(
                                    color: AppPallete.whiteColor,
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.04),
                              
                              // Publish button
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  constraints: BoxConstraints(maxWidth: 400),
                                  child: AuthGradientButton(
                                    buttonText: 'Publish Blog',
                                    onPressed: _handleCreateBlog,
                                    isLoading: _isLoading,
                                    icon: Icons.publish,
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
            ],
          ),
        ],
      ),
    );
  }
}