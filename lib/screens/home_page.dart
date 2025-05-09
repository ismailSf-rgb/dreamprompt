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

  @override
  void initState() {
    super.initState();
    _promptBloc = context.read<PromptBloc>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _promptBloc.add(const Load());
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      _promptBloc.add(const Load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocConsumer<PromptBloc, PromptState>(
        listener: (context, state) {
          if (state.loadingResult.error != null) {
            _promptBloc.add(const ClearError());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to perform this action'),
              ),
            );
          }
        },
        builder: (context, state) {
          return state.loadingResult.isInProgress && state.page == 0
          ? const PromptCardShimmer()
          : ListView.builder(
              controller: _scrollController, // Attach the scroll controller
              itemCount: state.items.length + 1, // +1 for the loading indicator
              itemBuilder: (context, index) {
                if (index < state.items.length) {
                  // Display a prompt
                  final prompt = state.items.values.elementAt(index);
                  return PromptCard(
                    prompt: prompt,
                    onTap: () {
                      // Navigate to the prompt details screen
                      GoRouter.of(context).push('/prompt/${prompt.id}');
                    },
                    onUpvote: () => _upvotePrompt(prompt.id),
                    onDownvote: () => _downvotePrompt(prompt.id),
                    onComment: () => _showComments(prompt.id),
                    onShare: () => _sharePrompt(prompt.id),
                    onMoreActions: () => _showPromptOptions(prompt.id),
                  );
                } else {
                  // Display a loading indicator at the bottom
                  return state.loadingResult.isInProgress
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(); // Hide if no more items to load
                }
              },
            );
        },
      ),
    );
  }
  
  _upvotePrompt(String? id) {}
  
  _downvotePrompt(String? id) {}
  
  _showComments(String? id) {}
  
  _sharePrompt(String? id) {}
  
  _showPromptOptions(String? id) {}
}