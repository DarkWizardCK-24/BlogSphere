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

class _HomePageState extends State<HomePage> {
  final BlogService _blogService = BlogService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double maxCrossAxisExtent = screenSize.width;
    double childAspectRatio = 0.8;
    if (screenSize.width > 600) {
      maxCrossAxisExtent = screenSize.width / 2;
      childAspectRatio = 0.7;
    }
    if (screenSize.width > 900) {
      maxCrossAxisExtent = screenSize.width / 3;
    }
    if (screenSize.width > 1200) {
      maxCrossAxisExtent = screenSize.width / 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Blogg App', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(context, SignInPage.route());
            },
          ),
        ],
        backgroundColor: AppPallete.transparentColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<List<Blog>>(
            future: _blogService.getAllBlogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppPallete.errorColor)));
              }
              final blogs = snapshot.data ?? [];
              return GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                  vertical: constraints.maxHeight * 0.02,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: constraints.maxWidth * 0.05,
                  mainAxisSpacing: constraints.maxHeight * 0.02,
                ),
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return BlogCard(
                    blog: blog,
                    onTap: () {
                      Navigator.push(
                        context,
                        BlogDetailPage.route(blog),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CreateBlogPage.route(),
          ).then((_) => setState(() {}));
        },
        backgroundColor: AppPallete.gradient5,
        child: const Icon(Icons.add),
      ),
    );
  }
}