import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ideahub/provider/prompt_provider.dart';
import 'package:ideahub/provider/user_provider.dart';

class PromptScreen extends StatefulWidget {
  final String promptId;

  const PromptScreen({super.key, required this.promptId});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the prompt when the screen is loaded
    final promptProvider = Provider.of<PromptProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchCurrentUser();
      promptProvider.fetchPrompt(widget.promptId, userProvider.currentUser?.id ?? '');
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = context.watch<PromptProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: promptProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : promptProvider.prompts.isEmpty
              ? const Center(child: Text('Prompt not found'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text('Content: ${promptProvider.selectedPrompt?.id}'),
                    Text('Posted by: ${promptProvider.selectedPrompt?.ownerAlias}'),
                  ],
                ),
    );
  }
}