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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF252538) : Colors.grey.shade100,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: 12),
              _buildContent(context, isDark),
              if (prompt.aiAnswers.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildAIBadge(),
              ],
              const SizedBox(height: 14),
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _avatarColor(prompt.ownerAlias).withValues(alpha: 0.7),
                _avatarColor(prompt.ownerAlias),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              prompt.ownerAlias.isNotEmpty
                  ? prompt.ownerAlias[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prompt.ownerAlias,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                timeago.format(prompt.createdDate),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onMoreActions,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.more_horiz_rounded,
              color: isDark ? Colors.white38 : Colors.black38,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Text(
      prompt.content,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15,
        height: 1.55,
        color: isDark ? Colors.white.withValues(alpha: 0.87) : Colors.black87,
      ),
    );
  }

  Widget _buildAIBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withValues(alpha: 0.12),
            const Color(0xFF7C3AED).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 13, color: Color(0xFF3B82F6)),
          const SizedBox(width: 6),
          Text(
            '${prompt.aiAnswers.length} AI ${prompt.aiAnswers.length == 1 ? 'answer' : 'answers'}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    final mutedColor = isDark ? Colors.white38 : Colors.black38;

    return Row(
      children: [
        // Vote pill
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _VoteButton(
                icon: Icons.arrow_upward_rounded,
                color: prompt.stars > 0 ? const Color(0xFFFF6B35) : mutedColor,
                onTap: onUpvote,
              ),
              Text(
                prompt.stars.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: prompt.stars > 0
                      ? const Color(0xFFFF6B35)
                      : (prompt.stars < 0 ? const Color(0xFF3B82F6) : mutedColor),
                ),
              ),
              _VoteButton(
                icon: Icons.arrow_downward_rounded,
                color: prompt.stars < 0 ? const Color(0xFF3B82F6) : mutedColor,
                onTap: onDownvote,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Comments
        GestureDetector(
          onTap: onComment,
          child: Row(
            children: [
              Icon(Icons.mode_comment_outlined, size: 16, color: mutedColor),
              const SizedBox(width: 5),
              Text(
                prompt.comments.length.toString(),
                style: TextStyle(fontSize: 13, color: mutedColor),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Share
        GestureDetector(
          onTap: onShare,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.ios_share_rounded, size: 18, color: mutedColor),
          ),
        ),
      ],
    );
  }

  Color _avatarColor(String alias) {
    const palette = [
      Color(0xFF7C3AED),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
    ];
    final index = alias.isEmpty ? 0 : alias.codeUnitAt(0) % palette.length;
    return palette[index];
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _VoteButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
