import '../service/prompt_service.dart';
import '../model/prompt.dart';
import '../model/comment.dart';
import '../model/answer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../util/subscription_manager.dart';

class PromptProvider with ChangeNotifier {
  final PromptService _promptService;
  final SubscriptionManager _subscriptionManager = SubscriptionManager();
  List<Prompt> _prompts = [];
  late Prompt _selectedPrompt;
  bool _isLoading = false;
  String? _errorMessage;

  PromptProvider(this._promptService);

  // Getters
  List<Prompt> get prompts => List.unmodifiable(_prompts);
  Prompt get selectedPrompt => _selectedPrompt;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Helper method to update a prompt in the list
  void _updatePrompt(Prompt updatedPrompt) {
    _prompts = _prompts.map((p) => p.id == updatedPrompt.id ? updatedPrompt : p).toList();
    notifyListeners();
  }

  // Helper method to add a prompt to the list (if it doesn't already exist)
  void _addPrompt(Prompt prompt) {
    if (!_prompts.any((p) => p.id == prompt.id)) {
      _prompts = [..._prompts, prompt];
      _selectedPrompt = prompt.copyWith();
    } else {
      _selectedPrompt = prompt.copyWith();
    }
  }

  // Fetch all prompts and update the state
  Future<void> fetchAllPrompts(String userId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final promptStream = _promptService.fetchAllPrompts(userId);
      _subscriptionManager.addSubscription(
        'fetchAllPrompts',
        promptStream.listen(
          (promptList) {
            _prompts = promptList;
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch prompts: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch more prompts and update the state
  Future<void> fetchMorePrompts(int page, String userId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final promptStream = _promptService.fetchMorePrompts(page, userId);
      _subscriptionManager.addSubscription(
        'fetchMorePrompts',
        promptStream.listen(
          (promptList) {
            // Avoid duplicates
            final newPrompts = promptList.where((prompt) => !_prompts.any((p) => p.id == prompt.id)).toList();
            _prompts = [..._prompts, ...newPrompts];
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch more prompts: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch more prompts from a specific owner and update the state
  Future<void> fetchMorePromptFromOwner(String ownerId, int page) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final promptStream = _promptService.fetchMorePromptFromOwner(ownerId, page);
      _subscriptionManager.addSubscription(
        'fetchMorePromptFromOwner',
        promptStream.listen(
          (promptList) {
            // Avoid duplicates
            final newPrompts = promptList.where((prompt) => !_prompts.any((p) => p.id == prompt.id)).toList();
            _prompts = [..._prompts, ...newPrompts];
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch prompts from owner: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch a single prompt by ID and update the state
  Future<void> fetchPrompt(String id, String userId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final promptStream = _promptService.fetchPrompt(id, userId);
      _subscriptionManager.addSubscription(
        'fetchPrompt',
        promptStream.listen(
          (prompt) {
            _addPrompt(prompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to fetch prompt: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Post a new prompt and add it to the state
  Future<void> postPrompt(Prompt prompt) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final newPrompt = await _promptService.postPrompt(prompt);
      _addPrompt(newPrompt);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to post prompt: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Remove a prompt by ID and update the state
  Future<void> removePrompt(String promptId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      await _promptService.removePrompt(promptId);
      _prompts = _prompts.where((p) => p.id != promptId).toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to remove prompt: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add a comment to a specific prompt
  Future<void> addComment(String promptId, Comment comment) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.addCommentToPrompt(promptId, comment);
      _subscriptionManager.addSubscription(
        'addComment',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to add comment: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Increment the stars of a specific prompt
  Future<void> incrementStars(String promptId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.incrementPromptStars(promptId);
      _subscriptionManager.addSubscription(
        'incrementStars',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to increment stars: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing prompt
  Future<void> updatePrompt(Prompt prompt) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.updatePrompt(prompt);
      _subscriptionManager.addSubscription(
        'updatePrompt',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to update prompt: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update an existing comment
  Future<void> updateComment(Comment comment) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedCommentStream = _promptService.updateComment(comment);
      _subscriptionManager.addSubscription(
        'updateComment',
        updatedCommentStream.listen(
          (updatedComment) {
            // Find the prompt containing the comment and update it
            final prompt = _prompts.firstWhere(
              (p) => p.comments.any((c) => c.id == updatedComment.id),
              orElse: () => throw Exception('Prompt not found'),
            );
            final updatedPrompt = prompt.copyWith(
              comments: prompt.comments.map((c) => c.id == updatedComment.id ? updatedComment : c).toList(),
            );
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to update comment: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Remove a star from a prompt
  Future<void> removePromptStar(String promptId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.removePromptStar(promptId);
      _subscriptionManager.addSubscription(
        'removePromptStar',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to remove star: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Upvote an answer
  Future<void> upvoteAnswer(String promptId, String answerId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.upvoteAnswer(promptId, answerId);
      _subscriptionManager.addSubscription(
        'upvoteAnswer',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to upvote answer: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Downvote an answer
  Future<void> downvoteAnswer(String promptId, String answerId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.downvoteAnswer(promptId, answerId);
      _subscriptionManager.addSubscription(
        'downvoteAnswer',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to downvote answer: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add an answer or a list of answers to a prompt
  Future<void> postAnswer(String promptId, List<Answer> answers) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.postAnswer(promptId, answers);
      _subscriptionManager.addSubscription(
        'postAnswer',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to post answer: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Remove an answer from a prompt
  Future<void> removeAnswer(String promptId, String answerId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.removeAnswer(promptId, answerId);
      _subscriptionManager.addSubscription(
        'removeAnswer',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to remove answer: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update an answer in a prompt
  Future<void> updateAnswer(String promptId, String answerId, Answer updatedAnswer) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    try {
      final updatedPromptStream = _promptService.updateAnswer(promptId, answerId, updatedAnswer);
      _subscriptionManager.addSubscription(
        'updateAnswer',
        updatedPromptStream.listen(
          (updatedPrompt) {
            _updatePrompt(updatedPrompt);
            _isLoading = false;
            notifyListeners();
          },
          onError: (err) {
            _errorMessage = 'Failed to update answer: $err';
            _isLoading = false;
            notifyListeners();
          },
        ),
      );
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions when the provider is disposed
    _subscriptionManager.cancelAll();
    super.dispose();
  }
}