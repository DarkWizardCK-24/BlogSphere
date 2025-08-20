import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/models/blog_model.dart';
import 'package:bloggg_app/pages/edit_blog_page.dart';
import 'package:bloggg_app/services/auth_service.dart';
import 'package:bloggg_app/services/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlogDetailPage extends StatefulWidget {
  final Blog blog;
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogDetailPage(blog: blog));
  const BlogDetailPage({super.key, required this.blog});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final BlogService _blogService = BlogService();
  
  late AnimationController _animationController;
  late AnimationController _fabController;
  late AnimationController _parallaxController;
  late AnimationController _heartController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fabAnimation;
  late Animation<double> _heartAnimation;
  
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _showFab = false;
  bool _isLiked = false;
  int _readingProgress = 0;

  bool get isOwner => _authService.currentUser?.id == widget.blog.posterId;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupScrollListener();
    _startAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );
    
    _heartAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;
      
      setState(() {
        _isScrolled = offset > 100;
        _showFab = offset > 200;
        _readingProgress = ((offset / maxScroll) * 100).clamp(0, 100).toInt();
      });
      
      if (_isScrolled && !_fabController.isCompleted) {
        _fabController.forward();
      } else if (!_isScrolled && _fabController.isCompleted) {
        _fabController.reverse();
      }
    });
  }

  void _startAnimations() {
    _animationController.forward();
    _parallaxController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
    _parallaxController.dispose();
    _heartController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _deleteBlog() async {
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    try {
      await _blogService.deleteBlog(widget.blog.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.white),
              SizedBox(width: 8),
              Text('Blog deleted successfully'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Failed to delete: $e')),
            ],
          ),
          backgroundColor: AppPallete.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    _heartController.forward().then((_) => _heartController.reverse());
    HapticFeedback.lightImpact();
  }

  void _shareContent() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.share, color: Colors.white),
            SizedBox(width: 8),
            Text('Share functionality would be implemented here'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppPallete.errorColor),
            SizedBox(width: 12),
            Text('Delete Blog'),
          ],
        ),
        content: Text('Are you sure you want to delete this blog? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBlog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  int _calculateReadingTime(String content) {
    final wordCount = content.split(' ').length;
    return (wordCount / 200).ceil(); // Average reading speed: 200 words per minute
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _isScrolled ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: Text(
            widget.blog.title,
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: _isScrolled 
            ? AppPallete.backgroundColor.withOpacity(0.95)
            : Colors.transparent,
        elevation: _isScrolled ? 4 : 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPallete.backgroundColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppPallete.borderColor.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          if (isOwner) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppPallete.borderColor.withOpacity(0.3)),
              ),
              child: IconButton(
                icon: Icon(Icons.edit_rounded, color: AppPallete.gradient5),
                onPressed: () {
                  Navigator.push(
                    context,
                    EditBlogPage.route(widget.blog),
                  ).then((_) => Navigator.pop(context));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppPallete.borderColor.withOpacity(0.3)),
              ),
              child: IconButton(
                icon: Icon(Icons.delete_rounded, color: AppPallete.errorColor),
                onPressed: () => _showDeleteDialog(),
              ),
            ),
          ],
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppPallete.backgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPallete.borderColor.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: Icon(Icons.share_rounded, color: AppPallete.gradient2),
              onPressed: _shareContent,
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: _showFab
                ? FloatingActionButton.extended(
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    backgroundColor: AppPallete.gradient5,
                    icon: Icon(Icons.keyboard_arrow_up_rounded),
                    label: Text('Top'),
                  )
                : SizedBox.shrink(),
          );
        },
      ),
      body: Stack(
        children: [
          // Reading Progress Indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isScrolled ? 4 : 0,
              child: LinearProgressIndicator(
                value: _readingProgress / 100,
                backgroundColor: AppPallete.borderColor.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppPallete.gradient2),
              ),
            ),
          ),
          
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Header
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: AnimatedBuilder(
                    animation: _parallaxController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppPallete.gradient1.withOpacity(0.8),
                              AppPallete.gradient2.withOpacity(0.6),
                              AppPallete.gradient3.withOpacity(0.4),
                            ],
                            stops: [
                              0.3 + (_parallaxController.value * 0.1),
                              0.6 + (_parallaxController.value * 0.1),
                              1.0,
                            ],
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppPallete.backgroundColor.withOpacity(0.7),
                                AppPallete.backgroundColor,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 800 : double.infinity,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? (screenSize.width - 800) / 2 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Meta Info
                          Container(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  widget.blog.title,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppPallete.whiteColor,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 20),
                                
                                // Author and Date Info
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppPallete.greyColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppPallete.borderColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [AppPallete.gradient1, AppPallete.gradient2],
                                          ),
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.blog.posterName.isNotEmpty
                                                ? widget.blog.posterName[0].toUpperCase()
                                                : 'A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      
                                      // Author Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.blog.posterName,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppPallete.whiteColor,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 16,
                                                  color: AppPallete.greyColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  _formatDate(widget.blog.createdAt),
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppPallete.greyColor,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Icon(
                                                  Icons.schedule_rounded,
                                                  size: 16,
                                                  color: AppPallete.greyColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${_calculateReadingTime(widget.blog.content)} min read',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppPallete.greyColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Content
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppPallete.greyColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppPallete.borderColor.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    widget.blog.content,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.8,
                                      fontSize: 16,
                                      color: AppPallete.whiteColor.withOpacity(0.9),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                
                                // Engagement Section
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppPallete.gradient1.withOpacity(0.1),
                                        AppPallete.gradient2.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppPallete.borderColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Enjoyed this article?',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppPallete.whiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildActionButton(
                                            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                                            label: _isLiked ? 'Liked' : 'Like',
                                            onTap: _toggleLike,
                                            color: AppPallete.errorColor,
                                          ),
                                          _buildActionButton(
                                            icon: Icons.share_rounded,
                                            label: 'Share',
                                            onTap: _shareContent,
                                            color: AppPallete.gradient2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 100), // Bottom padding for FAB
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}