import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ideahub/bloc/prompt_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/bloc/prompt_state.dart';
import 'package:ideahub/widgets/prompt_card.dart';
import 'package:ideahub/widgets/prompt_card_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PromptBloc _promptBloc;
  late final ScrollController _scrollController;
  int _selectedCategory = 0;

  static const _categories = ['All', 'AI Models', 'Writing', 'Coding', 'Creative', 'Analysis'];

  @override
  void initState() {
    super.initState();
    _promptBloc = context.read<PromptBloc>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _promptBloc.add(const Load());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _promptBloc.add(const LoadMore());
    }
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
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildCategoryChips(isDark),
            Expanded(
              child: BlocConsumer<PromptBloc, PromptState>(
                listener: (context, state) {
                  if (state.loadingResult.error != null) {
                    _promptBloc.add(const ClearError());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: const Text('Failed to perform this action'),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.loadingResult.isInProgress && state.page == 0) {
                    return const PromptCardShimmer();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: state.items.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.items.length) {
                        final prompt = state.items.values.elementAt(index);
                        return PromptCard(
                          prompt: prompt,
                          onTap: () {
                            _promptBloc.add(FetchItem(prompt));
                            GoRouter.of(context).push('/prompt/${prompt.id}');
                          },
                          onUpvote: () => _upvotePrompt(prompt.id),
                          onDownvote: () => _downvotePrompt(prompt.id),
                          onComment: () => _showComments(prompt.id),
                          onShare: () => _sharePrompt(prompt.id),
                          onMoreActions: () => _showPromptOptions(prompt.id),
                        );
                      }
                      return state.loadingResult.loadMoreInProgress
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: isDark
                                        ? const Color(0xFF7C3AED)
                                        : const Color(0xFF3B82F6),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IdeaHub',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.4,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'Share & discover AI prompts',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
          const Spacer(),
          _HeaderAction(
            icon: Icons.search_rounded,
            isDark: isDark,
            onTap: () {},
          ),
          _HeaderAction(
            icon: Icons.notifications_none_rounded,
            isDark: isDark,
            onTap: () {},
            badge: true,
          ),
          const SizedBox(width: 4),
          _UserAvatar(isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark ? const Color(0xFF1A1A28) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? const Color(0xFF2C2C40) : Colors.grey.shade200),
                  ),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).push('/create'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Prompt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  _upvotePrompt(String? id) {}
  _downvotePrompt(String? id) {}
  _showComments(String? id) {}
  _sharePrompt(String? id) {}
  _showPromptOptions(String? id) {}
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  final bool badge;

  const _HeaderAction({
    required this.icon,
    required this.isDark,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(icon, color: isDark ? Colors.white60 : Colors.black54, size: 24),
          onPressed: onTap,
        ),
        if (badge)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF7C3AED),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final bool isDark;

  const _UserAvatar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: const Center(
          child: Text(
            'U',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
