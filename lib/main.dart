import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'provider/prompt_provider.dart';
import 'provider/user_provider.dart';
import 'service/user_mock_service.dart';
import 'service/mock_prompt_service.dart';
import 'screens/home_screen.dart';
import 'screens/user_screen.dart';
import 'screens/prompt_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PromptProvider(MockPromptService())),
        ChangeNotifierProvider(create: (_) => UserProvider(MockUserService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the GoRouter configuration
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/user/:id',
          builder: (context, state) {
            // Access the 'id' parameter using state.params
            final userId = state.params['id']!;
            return UserScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/prompt/:id',
          builder: (context, state) {
            // Access the 'id' parameter using state.params
            final promptId = state.params['id']!;
            return PromptScreen(promptId: promptId);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'IdeaHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Light theme (optional)
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Dark theme
      ),
      themeMode: ThemeMode.dark, // Force dark mode by default
    );
  }
}