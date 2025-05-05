import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ideahub/provider/user_provider.dart';

class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    // Fetch user details when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchUser(userId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.currentUser == null
              ? const Center(child: Text('User not found'))
              : Column(
                  children: [
                    Text('Alias: ${userProvider.currentUser!.alias}'),
                    Text('Picture URL: ${userProvider.currentUser!.pictureUrl}'),
                  ],
                ),
    );
  }
}