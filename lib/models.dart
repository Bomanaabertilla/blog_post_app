class User {
  final String id;
  final String username;
  final String password;
  
  User({
    required this.id,
    required this.username,
    required this.password,
  });
}

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;
  final List<String> likes;
  
  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
    required this.likes,
  });
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;
  
  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });
}