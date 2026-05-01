import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ideahub/bloc/prompt_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/bloc/prompt_state.dart';
import 'package:ideahub/model/answer.dart';
import 'package:ideahub/model/comment.dart';
import 'package:ideahub/model/prompt.dart';
import 'package:timeago/timeago.dart' as timeago;

class PromptPage extends StatefulWidget {
  const PromptPage({super.key});

  @override
  State<PromptPage> createState() => _PromptPageState();
}

class _PromptPageState extends State<PromptPage> {
  late final PromptBloc _promptBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _promptBloc = context.read<PromptBloc>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A14) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: BlocConsumer<PromptBloc, PromptState>(
          listener: (context, state) {
            if (state.loadingResult.error != null) {
              _promptBloc.add(const ClearError());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: const Text('Failed to perform this action'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.loadingResult.isInProgress) {
              return _buildLoading(isDark);
            }

            final prompt = state.selectedPrompt;
            if (prompt == null) {
              return _buildNotFound(context, isDark);
            }

            return Column(
              children: [
                _buildTopBar(context, prompt, isDark),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: _PromptBody(prompt: prompt, isDark: isDark),
                      ),
                      if (prompt.aiAnswers.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _SectionHeader(
                            icon: Icons.auto_awesome_rounded,
                            label: 'AI Answers',
                            count: prompt.aiAnswers.length,
                            isDark: isDark,
                            accentColor: const Color(0xFF3B82F6),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => _AnswerCard(
                              answer: prompt.aiAnswers[i],
                              isDark: isDark,
                            ),
                            childCount: prompt.aiAnswers.length,
                          ),
                        ),
                      ],
                      if (prompt.comments.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _SectionHeader(
                            icon: Icons.mode_comment_outlined,
                            label: 'Comments',
                            count: prompt.comments.length,
                            isDark: isDark,
                            accentColor: const Color(0xFF10B981),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => _CommentCard(
                              comment: prompt.comments[i],
                              isDark: isDark,
                            ),
                            childCount: prompt.comments.length,
                          ),
                        ),
                      ],
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Prompt prompt, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Prompt',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.ios_share_rounded,
                color: isDark ? Colors.white54 : Colors.black45, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border_rounded,
                color: isDark ? Colors.white54 : Colors.black45, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: isDark ? const Color(0xFF7C3AED) : const Color(0xFF3B82F6),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 12),
          Text('Prompt not found',
              style: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 16)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }
}

// ── Prompt body ──────────────────────────────────────────────────────────────

class _PromptBody extends StatelessWidget {
  final Prompt prompt;
  final bool isDark;

  const _PromptBody({required this.prompt, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF252538) : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                _Avatar(alias: prompt.ownerAlias, radius: 20),
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
                _VotePill(stars: prompt.stars, isDark: isDark),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              color: isDark
                  ? const Color(0xFF252538)
                  : Colors.grey.shade100,
            ),
          ),

          // Prompt content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SelectableText(
              prompt.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.65,
                color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                letterSpacing: 0.1,
              ),
            ),
          ),

          // Copy button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: _CopyButton(text: prompt.content, isDark: isDark),
          ),

          // Stats footer
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F0F1C)
                  : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20)),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF252538)
                      : Colors.grey.shade100,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.mode_comment_outlined,
                  label: '${prompt.comments.length} comments',
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                if (prompt.aiAnswers.isNotEmpty)
                  _StatChip(
                    icon: Icons.auto_awesome_rounded,
                    label: '${prompt.aiAnswers.length} AI ${prompt.aiAnswers.length == 1 ? 'answer' : 'answers'}',
                    isDark: isDark,
                    color: const Color(0xFF3B82F6),
                  ),
                const Spacer(),
                Text(
                  timeago.format(prompt.lastModifiedDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isDark;
  final Color accentColor;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.count,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : Colors.black54,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Answer card ──────────────────────────────────────────────────────────────

class _AnswerCard extends StatefulWidget {
  final Answer answer;
  final bool isDark;

  const _AnswerCard({required this.answer, required this.isDark});

  @override
  State<_AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<_AnswerCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final source = widget.answer.source;
    final sourceColor = _sourceColor(source);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF13131F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDark
              ? const Color(0xFF252538)
              : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              child: Row(
                children: [
                  // Model icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: sourceColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _sourceInitial(source),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: sourceColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              source,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _CategoryBadge(
                              label: widget.answer.category,
                              isDark: widget.isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.thumb_up_outlined,
                                size: 11,
                                color: widget.isDark
                                    ? Colors.white38
                                    : Colors.black38),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.answer.upvotes}',
                              style: TextStyle(
                                fontSize: 11,
                                color: widget.isDark
                                    ? Colors.white38
                                    : Colors.black38,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.thumb_down_outlined,
                                size: 11,
                                color: widget.isDark
                                    ? Colors.white24
                                    : Colors.black26),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.answer.downvotes}',
                              style: TextStyle(
                                fontSize: 11,
                                color: widget.isDark
                                    ? Colors.white24
                                    : Colors.black26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: widget.isDark ? Colors.white38 : Colors.black38,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedCrossFade(
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 1,
                  color: widget.isDark
                      ? const Color(0xFF252538)
                      : Colors.grey.shade100,
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: SelectableText(
                    widget.answer.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.65,
                      color: widget.isDark
                          ? Colors.white.withValues(alpha: 0.82)
                          : Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: _CopyButton(
                      text: widget.answer.content, isDark: widget.isDark),
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }

  Color _sourceColor(String source) {
    final s = source.toLowerCase();
    if (s.contains('gpt') || s.contains('openai')) return const Color(0xFF10B981);
    if (s.contains('claude') || s.contains('anthropic')) return const Color(0xFFF97316);
    if (s.contains('gemini') || s.contains('google')) return const Color(0xFF3B82F6);
    if (s.contains('llama') || s.contains('meta')) return const Color(0xFFA855F7);
    if (s.contains('mistral')) return const Color(0xFF06B6D4);
    return const Color(0xFF6B7280);
  }

  String _sourceInitial(String source) {
    if (source.toLowerCase().contains('gpt')) return 'G';
    if (source.toLowerCase().contains('claude')) return 'C';
    if (source.toLowerCase().contains('gemini')) return 'G';
    if (source.toLowerCase().contains('llama')) return 'L';
    if (source.toLowerCase().contains('mistral')) return 'M';
    return source.isNotEmpty ? source[0].toUpperCase() : '?';
  }
}

// ── Comment card ─────────────────────────────────────────────────────────────

class _CommentCard extends StatelessWidget {
  final Comment comment;
  final bool isDark;

  const _CommentCard({required this.comment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(alias: comment.ownerId, radius: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF13131F)
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF252538)
                      : Colors.grey.shade100,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.ownerId,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeago.format(comment.createdDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.82)
                          : Colors.black87,
                    ),
                  ),
                  if (comment.stars > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 13,
                            color: const Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          '${comment.stars}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ─────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String alias;
  final double radius;

  const _Avatar({required this.alias, required this.radius});

  @override
  Widget build(BuildContext context) {
    const palette = [
      Color(0xFF7C3AED), Color(0xFF3B82F6), Color(0xFF10B981),
      Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEC4899),
    ];
    final color = alias.isEmpty
        ? palette[0]
        : palette[alias.codeUnitAt(0) % palette.length];

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          alias.isNotEmpty ? alias[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.85,
          ),
        ),
      ),
    );
  }
}

class _VotePill extends StatelessWidget {
  final int stars;
  final bool isDark;

  const _VotePill({required this.stars, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isPositive = stars > 0;
    final color = isPositive
        ? const Color(0xFFFF6B35)
        : stars < 0
            ? const Color(0xFF3B82F6)
            : (isDark ? Colors.white38 : Colors.black38);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : stars < 0
                    ? Icons.arrow_downward_rounded
                    : Icons.remove_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            stars.abs().toString(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color? color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? (isDark ? Colors.white38 : Colors.black38);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: c)),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final bool isDark;

  const _CategoryBadge({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  final bool isDark;

  const _CopyButton({required this.text, required this.isDark});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _copied
              ? const Color(0xFF10B981).withValues(alpha: 0.15)
              : (widget.isDark
                  ? const Color(0xFF1E1E2E)
                  : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _copied
                ? const Color(0xFF10B981).withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              size: 14,
              color: _copied
                  ? const Color(0xFF10B981)
                  : (widget.isDark ? Colors.white38 : Colors.black38),
            ),
            const SizedBox(width: 6),
            Text(
              _copied ? 'Copied!' : 'Copy prompt',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _copied
                    ? const Color(0xFF10B981)
                    : (widget.isDark ? Colors.white38 : Colors.black38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
