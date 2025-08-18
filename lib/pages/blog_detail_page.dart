import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/models/blog_model.dart';
import 'package:bloggg_app/pages/edit_blog_page.dart';
import 'package:bloggg_app/services/auth_service.dart';
import 'package:bloggg_app/services/blog_service.dart';
import 'package:flutter/material.dart';

class BlogDetailPage extends StatefulWidget {
  final Blog blog;
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogDetailPage(blog: blog));
  const BlogDetailPage({super.key, required this.blog});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final AuthService _authService = AuthService();
  final BlogService _blogService = BlogService();

  bool get isOwner => _authService.currentUser?.id == widget.blog.posterId;

  Future<void> _deleteBlog() async {
    try {
      await _blogService.deleteBlog(widget.blog.id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete: $e'),
          backgroundColor: AppPallete.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.blog.title,
          style: Theme.of(context).textTheme.headlineMedium,
          overflow: TextOverflow.ellipsis,
        ),
        actions: isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      EditBlogPage.route(widget.blog),
                    ).then((_) => Navigator.pop(context));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Blog'),
                        content: const Text('Are you sure?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteBlog();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.05,
                vertical: constraints.maxHeight * 0.02,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : constraints.maxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: screenSize.height * 0.015),
                    Text(
                      'By ${widget.blog.posterName} on ${widget.blog.createdAt.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: screenSize.height * 0.03),
                    Text(
                      widget.blog.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
