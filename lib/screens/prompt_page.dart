import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ideahub/bloc/prompt_bloc.dart';
import 'package:ideahub/bloc/prompt_event.dart';
import 'package:ideahub/bloc/prompt_state.dart';


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
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return state.loadingResult.isInProgress
          ? const Center(child: CircularProgressIndicator())
          : state.items.isEmpty
              ? const Center(child: Text('Prompt not found'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text('Content: ${state.selectedPrompt?.id}'),
                    Text('Posted by: ${state.selectedPrompt?.ownerAlias}'),
                  ],
                );
        },
      ),
    );
  }
}