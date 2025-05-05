import 'dart:async';
import 'package:ideahub/util/delayer.dart';

import '../model/comment.dart';
import '../model/prompt.dart';
import 'prompt_service.dart';
import '../model/answer.dart';

class MockPromptService implements PromptService {
  // Private static instance of the class
  static final MockPromptService _instance = MockPromptService._internal();

  // Factory constructor to return the singleton instance
  factory MockPromptService() {
    return _instance;
  }

  // Private internal constructor
  MockPromptService._internal();

  @override
  Stream<Prompt> fetchPrompt(String id, String userId) async* {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate returning a prompt by id
    yield Prompt(
      id: id,
      content: 'Test Prompt',
      ownerId: 'owner1', // Keep as String
      ownerAlias: 'Owner1', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner1.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
    );
  }

  @override
  Stream<List<Prompt>> fetchAllPrompts(String userId) async* {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate returning all prompts
    yield [
      Prompt(
        id: '1',
        content: 'Test Prompt 1',
        ownerId: 'owner1', // Keep as String
        ownerAlias: 'Owner1', // Add ownerAlias
        ownerPictureUrl: 'https://example.com/owner1.jpg', // Add ownerPictureUrl
        createdDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      ),
      Prompt(
        id: '2',
        content: 'Test Prompt 2',
        ownerId: 'owner2', // Keep as String
        ownerAlias: 'Owner2', // Add ownerAlias
        ownerPictureUrl: 'https://example.com/owner2.jpg', // Add ownerPictureUrl
        createdDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      ),
    ];
  }

  @override
  Stream<List<Prompt>> fetchMorePrompts(int page, String userId) async* {
    // Hardcoded data for demonstration
    final List<Prompt> hardcodedPrompts = List.generate(
      10, // Number of prompts per page
      (index) => Prompt(
        id: '${index + (page * 10)}', // Unique ID based on page and index
        content: 'Prompt ${index + (page * 10)}', // Example content
        ownerId: 'user${index + (page * 10)}', // Keep as String
        ownerAlias: 'User${index + (page * 10)}', // Add ownerAlias
        ownerPictureUrl: 'https://example.com/user${index + (page * 10)}.jpg', // Add ownerPictureUrl
        createdDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example created date
        lastModifiedDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example last modified date
        comments: [], // Empty comments list
        stars: (index + (page * 10)) % 5, // Example stars (0 to 4)
      ),
    );

    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());

    // Yield the hardcoded prompts
    yield hardcodedPrompts;
  }

  @override
  Stream<List<Prompt>> fetchMorePromptFromOwner(String ownerId, int page) async* {
    // Hardcoded data for demonstration
    final List<Prompt> hardcodedPrompts = List.generate(
      10, // Number of prompts per page
      (index) => Prompt(
        id: '${index + (page * 10)}', // Unique ID based on page and index
        content: 'Prompt ${index + (page * 10)} by $ownerId', // Example content
        ownerId: ownerId, // Keep as String
        ownerAlias: 'User${index + (page * 10)}', // Add ownerAlias
        ownerPictureUrl: 'https://example.com/user${index + (page * 10)}.jpg', // Add ownerPictureUrl
        createdDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example created date
        lastModifiedDate: DateTime.now().subtract(Duration(days: index + (page * 10))), // Example last modified date
        comments: [], // Empty comments list
        stars: (index + (page * 10)) % 5, // Example stars (0 to 4)
      ),
    );

    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());

    // Yield the hardcoded prompts
    yield hardcodedPrompts;
  }

  @override
  Future<Prompt> postPrompt(Prompt prompt) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate posting a prompt
    return prompt;
  }

  @override
  Future<void> removePrompt(String promptId) async {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate removing a prompt
  }

  @override
  Stream<Prompt> addCommentToPrompt(String promptId, Comment comment) async* {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate adding a comment to the prompt
    yield Prompt(
      id: promptId,
      content: 'Updated Prompt with comment',
      ownerId: 'owner1', // Keep as String
      ownerAlias: 'Owner1', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner1.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      comments: [comment],
    );
  }

  @override
  Stream<Prompt> incrementPromptStars(String promptId) async* {
    // Simulate a delay to mimic network latency
    await Future.delayed(Delayer.delay());
    // Simulate incrementing the stars
    yield Prompt(
      id: promptId,
      content: 'Updated Prompt with stars',
      ownerId: 'owner1', // Keep as String
      ownerAlias: 'Owner1', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner1.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      stars: 6,  // Assume it increments to 6 stars
    );
  }

  @override
  Stream<Prompt> updatePrompt(Prompt prompt) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    yield prompt; // Return the same prompt as if it was updated
  }

  @override
  Stream<Comment> updateComment(Comment comment) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    yield comment; // Return the same comment as if it was updated
  }

  @override
  Stream<Prompt> removePromptStar(String promptId) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      stars: 0, // Removed star
    );
    yield prompt;
  }

  @override
  Stream<Prompt> upvoteAnswer(String promptId, String answerId) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      aiAnswers: [
        Answer(
          id: answerId,
          content: 'Mock Answer $answerId',
          source: 'OpenAI',
          category: 'code',
          upvotes: 1, // Incremented upvotes
          downvotes: 0,
          ownerId: 'owner$promptId', // Keep as String
        ),
      ],
    );
    yield prompt;
  }

  @override
  Stream<Prompt> downvoteAnswer(String promptId, String answerId) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      aiAnswers: [
        Answer(
          id: answerId,
          content: 'Mock Answer $answerId',
          source: 'OpenAI',
          category: 'code',
          upvotes: 0,
          downvotes: 1, // Incremented downvotes
          ownerId: 'owner$promptId', // Keep as String
        ),
      ],
    );
    yield prompt;
  }

  @override
  Stream<Prompt> postAnswer(String promptId, List<Answer> answers) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      aiAnswers: answers.map((answer) => Answer(
        id: answer.id,
        content: answer.content,
        source: answer.source,
        category: answer.category,
        upvotes: answer.upvotes,
        downvotes: answer.downvotes,
        ownerId: 'owner$promptId', // Keep as String
      )).toList(), // Add the new answers with ownerId
    );
    yield prompt;
  }

  @override
  Stream<Prompt> removeAnswer(String promptId, String answerId) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      aiAnswers: [], // Simulate removing the answer
    );
    yield prompt;
  }

  @override
  Stream<Prompt> updateAnswer(String promptId, String answerId, Answer updatedAnswer) async* {
    await Future.delayed(Delayer.delay()); // Simulate delay
    final prompt = Prompt(
      id: promptId,
      content: 'Mock Prompt $promptId',
      ownerId: 'owner$promptId', // Keep as String
      ownerAlias: 'Owner$promptId', // Add ownerAlias
      ownerPictureUrl: 'https://example.com/owner$promptId.jpg', // Add ownerPictureUrl
      createdDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      aiAnswers: [updatedAnswer], // Simulate updating the answer
    );
    yield prompt;
  }
}