import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../app_state.dart';
import '../screens/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User currentUser;

  const PostCard({super.key, required this.post, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final isOwner = post.authorId == currentUser.id;
    final isLiked = post.likes.contains(currentUser.id);
    final comments = appState.commentsForPost(post.id);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => appState.deletePost(post.id),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(post.text),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                    onPressed: () => appState.likePost(post.id),
                  ),
                  Text('${post.likes.length}'),
                  const SizedBox(width: 16),
                  Icon(Icons.comment, size: 20),
                  const SizedBox(width: 4),
                  Text('${comments.length}'),
                  const Spacer(),
                  Text(
                    '${post.createdAt.day}/${post.createdAt.month} ${post.createdAt.hour}:${post.createdAt.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
