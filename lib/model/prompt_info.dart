import 'package:ideahub/model/prompt.dart';
import 'package:ideahub/model/user.dart';

class PromptInfo {
  Map<String?, Prompt> items;
  int page;
  User runningUser;
  Prompt? selectedPrompt;

   PromptInfo({
    required this.items,
    required this.page,
    required this.runningUser,
    this.selectedPrompt,
  });
  
  PromptInfo copyWith({
    Map<String?, Prompt>? items,
    int? page,
    User? runningUser,
    Prompt? selectedPrompt,
  }) {
    return PromptInfo(
      items: items ?? this.items,
      page: page ?? this.page,
      runningUser: runningUser ?? this.runningUser,
      selectedPrompt: selectedPrompt ?? this.selectedPrompt,
    );
  }
}