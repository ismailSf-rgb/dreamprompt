import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideahub/bloc/prompt_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/repository/mock_prompt_repository.dart';
import 'package:ideahub/repository/prompt_repository.dart';
import 'package:ideahub/screens/home_page.dart';
import 'package:ideahub/screens/prompt_page.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Repository Providers
        RepositoryProvider<PromptRepository>(
          create: (_) => MockPromptRepository(),
        ),
        
        // Bloc Provider
        BlocProvider<PromptBloc>(
          create: (context) => PromptBloc(
            promptRepository: context.read<PromptRepository>(),
          )..add(const Load()), // Initial load event
        ),
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
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/prompt/:id',
          builder: (context, state) {
            //might have to put an id param
            return const PromptPage();
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