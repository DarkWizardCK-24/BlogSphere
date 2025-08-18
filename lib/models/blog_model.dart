class Blog {
  final String id;
  final String title;
  final String content;
  final String posterId;
  final String posterName;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.posterId,
    required this.posterName,
    required this.createdAt,
  });

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      posterId: map['poster_id'] as String,
      posterName: map['poster_name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'poster_id': posterId,
      'poster_name': posterName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
