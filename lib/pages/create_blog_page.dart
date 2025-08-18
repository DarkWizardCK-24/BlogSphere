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

class _CreateBlogPageState extends State<CreateBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final BlogService _blogService = BlogService();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateBlog() async {
    if (formKey.currentState!.validate()) {
      try {
        await _blogService.createBlog(
          titleController.text,
          contentController.text,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create blog: $e'),
            backgroundColor: AppPallete.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Blog',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: AppPallete.transparentColor,
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
                  maxWidth: isLargeScreen ? 600 : constraints.maxWidth,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Title is required' : null,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      TextFormField(
                        controller: contentController,
                        decoration: InputDecoration(
                          hintText: 'Content',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: isLargeScreen ? 15 : 10,
                        validator: (value) =>
                            value!.isEmpty ? 'Content is required' : null,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Center(
                        child: AuthGradientButton(
                          buttonText: 'Publish',
                          onPressed: _handleCreateBlog,
                        ),
                      ),
                    ],
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
