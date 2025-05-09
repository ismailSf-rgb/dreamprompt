import 'package:equatable/equatable.dart';
import 'package:ideahub/model/prompt.dart';
import 'package:ideahub/model/user.dart';
import 'package:ideahub/util/delayed_result.dart';

class PromptState extends Equatable {
  final Map<String?, Prompt> items;
  final int page;
  final User? runningUser;
  final Prompt? selectedPrompt;
  final DelayedResult<void> loadingResult;

  const PromptState({
    required this.items,
    required this.page,
    this.runningUser,
    this.selectedPrompt,
    required this.loadingResult,
  });

  PromptState copyWith({
    Map<String?, Prompt>? items,
    int? page,
    User? runningUser,
    Prompt? selectedPrompt,
    DelayedResult<void>? loadingResult
  }) {
    return PromptState(
      items: items ?? this.items,
      page: page ?? this.page,
      runningUser: runningUser ?? this.runningUser,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
      loadingResult: loadingResult ?? this.loadingResult,
    );
  }

  @override
  List<Object?> get props => [items, page, runningUser, selectedPrompt, loadingResult];
}