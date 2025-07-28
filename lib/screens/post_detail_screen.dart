import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models.dart';
import '../widgets/comment_tile.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      Provider.of<AppState>(
        context,
        listen: false,
      ).addComment(widget.post.id, _commentController.text.trim());
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final comments = appState.commentsForPost(widget.post.id);
    final currentUser = appState.currentUser!;
    final isLiked = widget.post.likes.contains(currentUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post content
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.post.createdAt.day}/${widget.post.createdAt.month} ${widget.post.createdAt.hour}:${widget.post.createdAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(widget.post.text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          appState.likePost(widget.post.id);
                        },
                      ),
                      Text('${widget.post.likes.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Comments section
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('(${comments.length})'),
                    ],
                  ),
                ),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(
                          child: Text(
                            'No comments yet. Be the first to comment!',
                          ),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) =>
                              CommentTile(comment: comments[index]),
                        ),
                ),
              ],
            ),
          ),

          // Add comment section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
