import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:provider/provider.dart';
import 'package:ideahub/provider/prompt_provider.dart';
import 'package:ideahub/provider/user_provider.dart';
import 'package:ideahub/widgets/prompt_card.dart';
import 'package:ideahub/widgets/prompt_card_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1; // Track the current page for pagination

  @override
  void initState() {
    super.initState();
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Fetch the first page of prompts when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchCurrentUser();
      promptProvider.fetchMorePrompts(_currentPage,userProvider.currentUser?.id ?? '');
    });
    

    // Add a listener to the scroll controller for infinite scrolling
    //_scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Reached the end of the list, fetch the next page
      _currentPage++;
      final promptProvider = context.watch<PromptProvider>();
      final userProvider = context.watch<UserProvider>();
      userProvider.fetchCurrentUser();
      promptProvider.fetchMorePrompts(_currentPage, userProvider.currentUser?.id ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = context.watch<PromptProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: promptProvider.isLoading && _currentPage == 1
          ? const PromptCardShimmer()
          : ListView.builder(
              controller: _scrollController, // Attach the scroll controller
              itemCount: promptProvider.prompts.length + 1, // +1 for the loading indicator
              itemBuilder: (context, index) {
                if (index < promptProvider.prompts.length) {
                  // Display a prompt
                  final prompt = promptProvider.prompts[index];
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
                  return promptProvider.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(); // Hide if no more items to load
                }
              },
            ),
    );
  }

  void _upvotePrompt(String? promptId) {}
  void _downvotePrompt(String? promptId) {}
  void _showComments(String? promptId) {}
  void _sharePrompt(String? promptId) {}
  void _showPromptOptions(String? promptId) {}
}