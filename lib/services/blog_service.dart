import 'package:bloggg_app/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Blog>> getAllBlogs() async {
    final response = await _supabase
        .from('blogs')
        .select()
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((json) => Blog.fromMap(json))
        .toList();
  }

  Future<void> createBlog(String title, String content) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final posterName = user.userMetadata?['name'] ?? 'Anonymous';

    await _supabase.from('blogs').insert({
      'title': title,
      'content': content,
      'poster_id': user.id,
      'poster_name': posterName,
    });
  }

  Future<void> updateBlog(String id, String title, String content) async {
    await _supabase
        .from('blogs')
        .update({'title': title, 'content': content})
        .eq('id', id);
  }

  Future<void> deleteBlog(String id) async {
    await _supabase.from('blogs').delete().eq('id', id);
  }
}
