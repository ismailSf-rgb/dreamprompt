import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/prompt.dart';

class PromptCard extends StatelessWidget {
  final Prompt prompt;
  final VoidCallback? onTap;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMoreActions;

  const PromptCard({
    required this.prompt,
    this.onTap,
    this.onUpvote,
    this.onDownvote,
    this.onComment,
    this.onShare,
    this.onMoreActions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info and timestamp
              _buildHeader(context),
              const SizedBox(height: 12),
              
              // Prompt content
              _buildContent(),
              const SizedBox(height: 12),
              
              // Action buttons
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          /*backgroundImage: NetworkImage(prompt.ownerPictureUrl),*/
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prompt.ownerAlias,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                timeago.format(prompt.createdDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          iconSize: 20,
          onPressed: onMoreActions,
          color: Theme.of(context).hintColor,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      prompt.content,
      style: const TextStyle(
        fontSize: 16,
        height: 1.4,
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Vote controls
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: prompt.stars > 0 ? Colors.orange : Theme.of(context).hintColor,
              ),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onUpvote,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                prompt.stars.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_downward,
                color: prompt.stars < 0 ? Colors.blue : Theme.of(context).hintColor,
              ),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDownvote,
            ),
          ],
        ),
        
        // Comments button
        TextButton.icon(
          onPressed: onComment,
          icon: const Icon(Icons.mode_comment_outlined, size: 18),
          label: Text(
            prompt.comments.length.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        
        // AI Answers indicator
        if (prompt.aiAnswers.isNotEmpty) ...[
          const Spacer(),
          Chip(
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.blue.withOpacity(0.1),
            label: Text(
              '${prompt.aiAnswers.length} AI ${prompt.aiAnswers.length == 1 ? 'answer' : 'answers'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                  ),
            ),
            avatar: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Colors.blue,
            ),
          ),
        ],
        
        const Spacer(),
        
        // Share button
        IconButton(
          icon: const Icon(Icons.share, size: 18),
          onPressed: onShare,
          color: Theme.of(context).hintColor,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}