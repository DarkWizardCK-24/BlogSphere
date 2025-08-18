import 'dart:math';
import 'package:bloggg_app/core/theme/app_pallete.dart';
import 'package:bloggg_app/models/blog_model.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;

  const BlogCard({super.key, required this.blog, required this.onTap});

  // Randomly select a gradient pair from AppPallete
  List<Color> _getRandomGradient() {
    final random = Random();
    final gradients = [
      AppPallete.gradient1,
      AppPallete.gradient2,
      AppPallete.gradient3,
      AppPallete.gradient4,
      AppPallete.gradient5,
      AppPallete.gradient6,
      AppPallete.gradient7,
      AppPallete.gradient8,
    ];
    gradients.shuffle(random);
    return gradients.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;
    final gradientColors = _getRandomGradient();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.03,
        vertical: screenSize.height * 0.01,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppPallete.whiteColor.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppPallete.whiteColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(
                      color: AppPallete.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isLargeScreen ? 22 : 18,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  Row(
                    children: [
                      Icon(Icons.person, color: AppPallete.whiteColor.withOpacity(0.8), size: isLargeScreen ? 18 : 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          blog.posterName,
                          style: TextStyle(
                            color: AppPallete.whiteColor.withOpacity(0.9),
                            fontSize: isLargeScreen ? 15 : 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.calendar_today, color: AppPallete.whiteColor.withOpacity(0.8), size: isLargeScreen ? 18 : 16),
                      SizedBox(width: 4),
                      Text(
                        blog.createdAt.toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          color: AppPallete.whiteColor.withOpacity(0.7),
                          fontSize: isLargeScreen ? 14 : 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Text(
                    '${blog.content.substring(0, blog.content.length > 100 ? 100 : blog.content.length)}...',
                    style: TextStyle(
                      color: AppPallete.whiteColor.withOpacity(0.85),
                      fontSize: isLargeScreen ? 15 : 13,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppPallete.whiteColor.withOpacity(0.7),
                      size: isLargeScreen ? 20 : 16,
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