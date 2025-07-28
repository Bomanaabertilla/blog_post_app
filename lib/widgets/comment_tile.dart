import 'package:flutter/material.dart';
import '../models.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            child: Text(
              comment.authorName[0].toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${comment.createdAt.day}/${comment.createdAt.month} ${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}