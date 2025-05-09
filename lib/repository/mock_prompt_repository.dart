import 'dart:async';
import 'dart:core'; 

import 'package:ideahub/model/answer.dart';
import 'package:ideahub/model/comment.dart';
import 'package:ideahub/model/prompt.dart';
import 'package:ideahub/model/prompt_info.dart';
import 'package:ideahub/model/user.dart';
import 'package:ideahub/repository/prompt_repository.dart';
import 'package:ideahub/util/delayer.dart';


class MockPromptRepository implements PromptRepository {
  final _promptInfoController = StreamController<PromptInfo>.broadcast();

  final PromptInfo _promptInfo = PromptInfo(
    items: {},
    page: 0,
    runningUser : User(
      id: '1',
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      interests: const [],
      alias: 'me', // Add alias
      pictureUrl: 'https://example.com/user1.jpg', // Add pictureUrl
    ),
  );

  PromptInfo get promptInfo => _promptInfo;

  @override
  Future<PromptInfo> get promptInfoFuture async => _promptInfo.copyWith(items: Map.unmodifiable(_promptInfo.items), runningUser: _promptInfo.runningUser, selectedPrompt: _promptInfo.selectedPrompt,);

  @override
  Stream<PromptInfo> get promptInfoStream => _promptInfoController.stream;

  @override
  Future<void> addCommentToPrompt(String promptId, Comment comment) {
    throw UnimplementedError();
  }

  @override
  Future<void> downvoteAnswer(String promptId, String answerId) {
    throw UnimplementedError();
  }

  @override
  Future<void> fetchMorePromptFromOwner(String ownerId, int page) {
    throw UnimplementedError();
  }

  @override
  Future<void> fetchMorePrompts(int page, String userId) {
    return Future.delayed(
    Delayer.delay(),
    () {
      final prompts = List.generate(
        10, // Number of prompts per page
        (index) => Prompt(
          id: '${index + (page * 10)}', // Unique ID based on page and index
          content: 'Prompt ${index + (page * 10)}', // Example content
          ownerId: 'user${index + (page * 10)}', // Keep as String
          ownerAlias: 'User${index + (page * 10)}', // Add ownerAlias
          ownerPictureUrl: 'https://example.com/user${index + (page * 10)}.jpg', // Add ownerPictureUrl
          createdDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example created date
          lastModifiedDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example last modified date
          comments: const [], // Empty comments list
          stars: (index + (page * 10)) % 5, // Example stars (0 to 4)
        ),
      );
      for (final prompt in prompts) {
        _promptInfo.items[prompt.id] = prompt;
      }
      _promptInfo.page = 0;
      final promptInfo = _promptInfo.copyWith(
        items: Map.unmodifiable(_promptInfo.items),
        page: _promptInfo.page
      );
      _promptInfoController.add(promptInfo);
    },
  );
  }

  @override
  Future<void> fetchPrompt(String id, String userId) {
   return Future.delayed(
    Delayer.delay(),
    () {
      // Check local cache first
      if (_promptInfo.items.containsKey(id)) {
        _promptInfo.selectedPrompt = _promptInfo.items[id]!;
        final promptInfo = _promptInfo.copyWith(
          items: Map.unmodifiable(_promptInfo.items),
          selectedPrompt: _promptInfo.selectedPrompt,
        );
        _promptInfoController.add(promptInfo);
      } else {
        throw StateError(
          'Prompt $id not found. '
          'Available IDs: ${_promptInfo.items.keys.join(', ')}'
        );
      }
    }
  );

  }

  @override
  Future<void> getCurrentUser() async {
    _promptInfoController.add(_promptInfo);
  }

  @override
  Future<void> incrementPromptStars(String promptId) {
    throw UnimplementedError();
  }

  @override
  Future<void> postAnswer(String promptId, List<Answer> answers) {
    throw UnimplementedError();
  }

  @override
  Future<void> postPrompt(Prompt prompt) async {
    await Future.delayed(Delayer.delay());
    Prompt? existingItem = _promptInfo.items[prompt.id];
    if(existingItem != null) {
      throw StateError(
          'Prompt ${prompt.id} already exist. '
      );
    } else {
      _promptInfo.items[prompt.id] = prompt;
      _promptInfo.selectedPrompt = prompt;

      final promptInfo = _promptInfo.copyWith(
        items: Map.unmodifiable(_promptInfo.items),
        selectedPrompt: _promptInfo.selectedPrompt,
      );
      
      _promptInfoController.add(promptInfo);
    } 
  }

  @override
  Future<void> removeAnswer(String promptId, String answerId) {
    throw UnimplementedError();
  }

  @override
  Future<void> removePrompt(String? promptId) async {
    await Future.delayed(Delayer.delay());
    Prompt? existingItem = _promptInfo.items[promptId];
    if(existingItem == null) {
      throw StateError(
          'Prompt $promptId doesnt exist. '
      );
    } else {
      _promptInfo.items.remove(existingItem.id);

      final promptInfo = _promptInfo.copyWith(
        items: Map.unmodifiable(_promptInfo.items),
      );
      
      _promptInfoController.add(promptInfo);
    } 
  }

  @override
  Future<void> removePromptStar(String promptId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAnswer(String promptId, String answerId, Answer updatedAnswer) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateComment(Comment comment) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePrompt(Prompt prompt) {
    throw UnimplementedError();
  }

  @override
  Future<void> upvoteAnswer(String promptId, String answerId) {
    throw UnimplementedError();
  }

   void dispose() {
    _promptInfoController.close();
  }

}