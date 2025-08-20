import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/models/blog_model.dart';
import 'package:bloggg_app/services/blog_service.dart';
import 'package:bloggg_app/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class EditBlogPage extends StatefulWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(builder: (context) => EditBlogPage(blog: blog));
  const EditBlogPage({super.key, required this.blog});

  @override
  State<EditBlogPage> createState() => _EditBlogPageState();
}

class _EditBlogPageState extends State<EditBlogPage> with TickerProviderStateMixin {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  final BlogService _blogService = BlogService();
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog.title);
    contentController = TextEditingController(text: widget.blog.content);
    
    // Listen for changes to show unsaved indicator
    titleController.addListener(_onTextChanged);
    contentController.addListener(_onTextChanged);
    
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges = titleController.text != widget.blog.title || 
                          contentController.text != widget.blog.content;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateBlog() async {
    if (formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        await Future.delayed(const Duration(milliseconds: 500)); // Show loading animation
        await _blogService.updateBlog(
          widget.blog.id,
          titleController.text,
          contentController.text,
        );
        
        // Success animation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Blog updated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(16),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context);
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to update: $e')),
              ],
            ),
            backgroundColor: AppPallete.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(16),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      // Form validation failed - shake animation
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await _showUnsavedChangesDialog();
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppPallete.gradient5, AppPallete.gradient2],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  'Edit Blog',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    background: Paint()
                      ..shader = LinearGradient(
                        colors: [AppPallete.transparentColor, AppPallete.transparentColor]
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: AppPallete.backgroundColor.withOpacity(0.9),
          elevation: 0,
          actions: [
            if (_hasUnsavedChanges)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      margin: EdgeInsets.only(right: 16, top: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Unsaved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppPallete.backgroundColor,
                AppPallete.backgroundColor.withOpacity(0.8),
                AppPallete.borderColor.withOpacity(0.3),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.05,
                    top: kToolbarHeight + 40,
                    bottom: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 700 : constraints.maxWidth,
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
                                // Floating decorative elements
                                AnimatedBuilder(
                                  animation: _floatingAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _floatingAnimation.value),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        margin: EdgeInsets.only(left: screenSize.width * 0.7),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [AppPallete.gradient1, AppPallete.gradient3],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppPallete.gradient1.withOpacity(0.3),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Title Field
                                _buildAnimatedField(
                                  controller: titleController,
                                  label: 'Blog Title',
                                  hint: 'Enter your amazing blog title...',
                                  icon: Icons.title_rounded,
                                  maxLines: 2,
                                  delay: 200,
                                ),
                                
                                SizedBox(height: 24),
                                
                                // Content Field
                                _buildAnimatedField(
                                  controller: contentController,
                                  label: 'Blog Content',
                                  hint: 'Share your thoughts and ideas...',
                                  icon: Icons.edit_note_rounded,
                                  maxLines: isLargeScreen ? 15 : 10,
                                  delay: 400,
                                ),
                                
                                SizedBox(height: 40),
                                
                                // Update Button
                                Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    child: _isLoading 
                                        ? Container(
                                            width: 200,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [AppPallete.gradient5, AppPallete.gradient2],
                                              ),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text('Updating...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppPallete.gradient5.withOpacity(0.3),
                                                  blurRadius: 20,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: AuthGradientButton(
                                              buttonText: 'Update Blog',
                                              onPressed: _handleUpdateBlog,
                                            ),
                                          ),
                                  ),
                                ),
                                
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int maxLines,
    required int delay,
  }) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(height: maxLines > 5 ? 200 : 80);
        }
        
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppPallete.gradient5.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppPallete.gradient5, AppPallete.gradient2],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(icon, size: 16, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: controller,
                      maxLines: maxLines,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPallete.greyColor.withOpacity(0.7),
                        ),
                        filled: true,
                        fillColor: AppPallete.borderColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppPallete.borderColor.withOpacity(0.5), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppPallete.gradient5, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppPallete.errorColor, width: 2),
                        ),
                        contentPadding: EdgeInsets.all(20),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '$label is required';
                        }
                        if (label.contains('Title') && value.trim().length < 3) {
                          return 'Title must be at least 3 characters long';
                        }
                        if (label.contains('Content') && value.trim().length < 10) {
                          return 'Content must be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppPallete.borderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Unsaved Changes', style: TextStyle(color: AppPallete.whiteColor)),
          ],
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: TextStyle(color: AppPallete.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Stay', style: TextStyle(color: AppPallete.gradient5)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Leave', style: TextStyle(color: AppPallete.errorColor)),
          ),
        ],
      ),
    ) ?? false;
  }
}