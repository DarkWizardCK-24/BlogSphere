import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/models/blog_model.dart';
import 'package:bloggg_app/pages/blog_detail_page.dart';
import 'package:bloggg_app/pages/create_blog_page.dart';
import 'package:bloggg_app/pages/sign_in_page.dart';
import 'package:bloggg_app/services/auth_service.dart';
import 'package:bloggg_app/services/blog_service.dart';
import 'package:bloggg_app/widgets/blog_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final BlogService _blogService = BlogService();
  final AuthService _authService = AuthService();

  late AnimationController _fabController;
  late AnimationController _headerController;
  late AnimationController _toggleController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _headerAnimation;
  late Animation<double> _toggleAnimation;

  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _headerAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    _toggleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _toggleController, curve: Curves.easeInOut),
    );

    _fabController.forward();
    _headerController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _headerController.dispose();
    _toggleController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppPallete.borderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPallete.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, color: AppPallete.errorColor),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Sign Out',
                style: TextStyle(color: AppPallete.whiteColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppPallete.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppPallete.gradient5),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _authService.signOut();
              Navigator.pushReplacement(context, SignInPage.route());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppPallete.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleView() {
    _toggleController.forward().then((_) {
      setState(() {
        _isGridView = !_isGridView;
      });
      _toggleController.reverse();
    });
  }

  Widget _buildListItem(Blog blog, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppPallete.greyColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.borderColor.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  [
                      AppPallete.gradient1,
                      AppPallete.gradient2,
                      AppPallete.gradient3,
                    ].sublist(index % 3, (index % 3) + 1)
                    ..addAll([AppPallete.gradient4]),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.article, color: AppPallete.whiteColor, size: 24),
        ),
        title: Text(
          blog.title,
          style: TextStyle(
            color: AppPallete.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              blog.content,
              style: TextStyle(color: AppPallete.greyColor, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: AppPallete.gradient5),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    blog.posterName,
                    style: TextStyle(
                      color: AppPallete.gradient5,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.schedule, size: 14, color: AppPallete.greyColor),
                const SizedBox(width: 4),
                Text(
                  _formatDate(blog.createdAt),
                  style: TextStyle(color: AppPallete.greyColor, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppPallete.gradient5,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BlogDetailPage(blog: blog),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double childAspectRatio = 0.75;
    int crossAxisCount = 1;

    // Better responsive design
    if (screenSize.width > 600) {
      childAspectRatio = 0.7;
      crossAxisCount = 2;
    }
    if (screenSize.width > 900) {
      crossAxisCount = 3;
      childAspectRatio = 0.65;
    }
    if (screenSize.width > 1200) {
      crossAxisCount = 4;
      childAspectRatio = 0.6;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Fixed App Bar with proper constraints
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: AppPallete.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: SlideTransition(
                position: _headerAnimation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppPallete.gradient4, AppPallete.gradient5],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.article,
                        color: AppPallete.whiteColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Bloggify',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader =
                                LinearGradient(
                                  colors: [
                                    AppPallete.gradient4,
                                    AppPallete.gradient5,
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              titlePadding: EdgeInsets.only(
                left: 16,
                bottom: 16,
                right: screenSize.width * 0.25,
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppPallete.backgroundColor,
                      AppPallete.gradient5.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Enhanced View toggle button
              AnimatedBuilder(
                animation: _toggleAnimation,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    constraints: BoxConstraints(maxWidth: 44, maxHeight: 44),
                    decoration: BoxDecoration(
                      color: AppPallete.borderColor.withOpacity(
                        0.3 + (_toggleAnimation.value * 0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppPallete.gradient5.withOpacity(
                          0.3 + (_toggleAnimation.value * 0.4),
                        ),
                        width: 1 + _toggleAnimation.value,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                        maxWidth: 44,
                        maxHeight: 44,
                      ),
                      icon: AnimatedRotation(
                        turns: _toggleAnimation.value * 0.5,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          _isGridView
                              ? Icons.view_list_rounded
                              : Icons.grid_view_rounded,
                          color: AppPallete.gradient5,
                          size: 20,
                        ),
                      ),
                      onPressed: _toggleView,
                    ),
                  );
                },
              ),
              // Logout button with constraints
              Container(
                margin: const EdgeInsets.only(right: 12),
                constraints: BoxConstraints(maxWidth: 44, maxHeight: 44),
                decoration: BoxDecoration(
                  color: AppPallete.borderColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                    maxWidth: 44,
                    maxHeight: 44,
                  ),
                  icon: const Icon(
                    Icons.logout,
                    color: AppPallete.errorColor,
                    size: 20,
                  ),
                  onPressed: _showLogoutDialog,
                ),
              ),
            ],
          ),

          // Blog content
          SliverToBoxAdapter(
            child: FutureBuilder<List<Blog>>(
              future: _blogService.getAllBlogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: screenSize.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppPallete.gradient4,
                                  AppPallete.gradient5,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(
                              color: AppPallete.whiteColor,
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Loading amazing blogs...',
                              style: TextStyle(
                                color: AppPallete.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    height: screenSize.height * 0.5,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPallete.errorColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppPallete.errorColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppPallete.errorColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Oops! Something went wrong',
                            style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: AppPallete.greyColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.gradient5,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: AppPallete.whiteColor),
                              const SizedBox(width: 8),
                              Text(
                                'Try Again',
                                style: TextStyle(color: AppPallete.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final blogs = snapshot.data ?? [];

                if (blogs.isEmpty) {
                  return Container(
                    height: screenSize.height * 0.6,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppPallete.gradient3.withOpacity(0.3),
                                AppPallete.gradient4.withOpacity(0.3),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: AppPallete.gradient4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No Blogs Yet',
                            style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Be the first to share your thoughts!\nTap the + button to create your first blog.',
                            style: TextStyle(
                              color: AppPallete.greyColor,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppPallete.gradient4.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppPallete.gradient4.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppPallete.gradient4,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Start your blogging journey today!',
                                  style: TextStyle(
                                    color: AppPallete.gradient4,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Blog list/grid with clear visual differences
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _isGridView
                      ? GridView.builder(
                          key: const ValueKey('grid_view'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            final blog = blogs[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 300 + (index * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 30 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: BlogCard(
                                      blog: blog,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => BlogDetailPage(blog: blog),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  const begin = Offset(
                                                    1.0,
                                                    0.0,
                                                  );
                                                  const end = Offset.zero;
                                                  const curve =
                                                      Curves.easeInOutCubic;

                                                  var tween =
                                                      Tween(
                                                        begin: begin,
                                                        end: end,
                                                      ).chain(
                                                        CurveTween(
                                                          curve: curve,
                                                        ),
                                                      );

                                                  return SlideTransition(
                                                    position: animation.drive(
                                                      tween,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        ).then((_) => setState(() {}));
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : ListView.builder(
                          key: const ValueKey('list_view'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            final blog = blogs[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 200 + (index * 50),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(-30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: _buildListItem(blog, index),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),

      // Enhanced FAB
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          constraints: BoxConstraints(maxWidth: screenSize.width * 0.4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppPallete.gradient5.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CreateBlogPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutCubic;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                ),
              ).then((_) => setState(() {}));
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppPallete.gradient4, AppPallete.gradient5],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppPallete.whiteColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: AppPallete.whiteColor, size: 20),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'New Blog',
                      style: TextStyle(
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
