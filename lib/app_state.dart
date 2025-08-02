import 'package:flutter/material.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  final List<User> _users = [];
  final List<Post> _posts = [];
  final List<Comment> _comments = [];
  User? _currentUser;
  bool _isDarkMode = false;
  
  User? get currentUser => _currentUser;
  List<User> get users => List.unmodifiable(_users);
  List<Post> get posts => List.unmodifiable(_posts);
  bool get isDarkMode => _isDarkMode;
  
  List<Comment> commentsForPost(String postId) {
    return _comments.where((comment) => comment.postId == postId).toList();
  }
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  bool login(String username, String password) {
    for (final user in _users) {
      if (user.username == username && user.password == password) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
    }
    return false;
  }
  
  bool register(String username, String password) {
    if (_users.any((user) => user.username == username)) {
      return false;
    }
    
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      password: password,
    );
    
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return true;
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
  
  bool userExists(String username) {
    return _users.any((user) => user.username == username);
  }
  
  bool resetPassword(String username, String newPassword) {
    final userIndex = _users.indexWhere((user) => user.username == username);
    if (userIndex != -1) {
      // Create a new user object with the updated password
      final oldUser = _users[userIndex];
      final updatedUser = User(
        id: oldUser.id,
        username: oldUser.username,
        password: newPassword,
      );
      _users[userIndex] = updatedUser;
      
      // If the current user is the one whose password was reset, update the current user reference
      if (_currentUser?.username == username) {
        _currentUser = updatedUser;
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  void addPost(String text) {
    if (_currentUser == null) return;
    
    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: _currentUser!.id,
      authorName: _currentUser!.username,
      text: text,
      createdAt: DateTime.now(),
      likes: [],
    );
    
    _posts.insert(0, post);
    notifyListeners();
  }
  
  void likePost(String postId) {
    if (_currentUser == null) return;
    
    final post = _posts.firstWhere((p) => p.id == postId);
    if (post.likes.contains(_currentUser!.id)) {
      post.likes.remove(_currentUser!.id);
    } else {
      post.likes.add(_currentUser!.id);
    }
    notifyListeners();
  }
  
  void deletePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    _comments.removeWhere((c) => c.postId == postId);
    notifyListeners();
  }
  
  void addComment(String postId, String text) {
    if (_currentUser == null) return;
    
    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      authorId: _currentUser!.id,
      authorName: _currentUser!.username,
      text: text,
      createdAt: DateTime.now(),
    );
    
    _comments.add(comment);
    notifyListeners();
  }
}