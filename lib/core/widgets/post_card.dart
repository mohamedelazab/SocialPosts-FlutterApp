import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'initials_avatar.dart';

/// Shared post summary card — used by the Feed (with author byline) and by
/// the Profile Posts tab (author omitted, since it's already the page owner).
class PostCard extends StatelessWidget {
  final String title;
  final String body;
  final int commentCount;
  final VoidCallback onTap;
  final String? authorName;
  final String? authorSubtitle;

  const PostCard({
    super.key,
    required this.title,
    required this.body,
    required this.commentCount,
    required this.onTap,
    this.authorName,
    this.authorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (authorName != null) ...[
                Row(
                  children: [
                    InitialsAvatar(name: authorName!, radius: 13),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          if (authorSubtitle != null &&
                              authorSubtitle!.isNotEmpty)
                            Text(
                              authorSubtitle!,
                              style:
                                  TextStyle(color: semantic.inkDim, fontSize: 10.5),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: semantic.inkDim, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.mode_comment_outlined,
                      size: 14, color: semantic.inkDim),
                  const SizedBox(width: 4),
                  Text(
                    "$commentCount",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 12, color: semantic.inkDim),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
