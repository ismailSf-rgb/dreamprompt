import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:ideahub/provider/prompt_provider.dart'; // Import your PromptProvider
import 'package:ideahub/provider/user_provider.dart'; // Import your UserProvider
import 'package:ideahub/model/model_factory.dart'; // Import the ModelFactory

class AddPromptDialog extends StatelessWidget {
  final TextEditingController _contentController = TextEditingController();

  AddPromptDialog({super.key});

  Future<void> _postPrompt(BuildContext context) async {
    // Validate input
    if (_contentController.text.isEmpty) {
      if (!context.mounted) return; // Guard the context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content for the prompt.')),
      );
      return;
    }

    final promptProvider = context.read<PromptProvider>();
    final userProvider = context.read<UserProvider>();

    try {
      // Fetch the current user
      await userProvider.fetchCurrentUser();
      if (!context.mounted) return; // Guard the context

      final currentUser = userProvider.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      // Create the prompt using the ModelFactory
      final prompt = ModelFactory.createPrompt(
        content: _contentController.text,
        ownerId: currentUser.id.toString(), // Use the current user's ID
        ownerAlias: currentUser.alias, // Use the current user's alias
        ownerPictureUrl: currentUser.pictureUrl, // Use the current user's picture URL
        createdDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );

      // Post the prompt
      await promptProvider.postPrompt(prompt);

      if (!context.mounted) return; // Guard the context
      // Close the dialog after posting
      Navigator.of(context).pop();
    } catch (error) {
      if (!context.mounted) return; // Guard the context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post prompt: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final promptProvider = context.watch<PromptProvider>();

    return AlertDialog(
      title: const Text('Add a Prompt'),
      content: TextField(
        controller: _contentController,
        decoration: const InputDecoration(hintText: 'Enter your prompt content'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: promptProvider.isLoading ? null : () => _postPrompt(context),
          child: promptProvider.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Post'),
        ),
      ],
    );
  }
}