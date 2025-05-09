import 'package:ideahub/model/answer.dart';
import 'package:ideahub/model/comment.dart';
import 'package:ideahub/model/prompt.dart';
import 'package:ideahub/model/prompt_info.dart';

abstract interface class PromptRepository {

  Stream<PromptInfo> get promptInfoStream;

  Future<PromptInfo> get promptInfoFuture;


  // Fetch a single prompt by ID (returns a stream of Prompt)
  Future<void> fetchPrompt(String id, String userId);

  // Fetch more prompts for pagination (returns a stream of a list of prompts)
  Future<void> fetchMorePrompts(int page, String userId);

  // Create a new prompt (returns the newly created prompt)
  Future<void> postPrompt(Prompt prompt);

  // Add a comment to a prompt by ID (returns the updated prompt with the new comment)
  Future<void> addCommentToPrompt(String promptId, Comment comment);

  // Increment stars for a prompt (returns the updated prompt with incremented stars)
  Future<void> incrementPromptStars(String promptId);

    // Update an existing prompt (returns the updated prompt)
  Future<void> updatePrompt(Prompt prompt);

  // Update an existing comment (returns the updated comment)
  Future<void> updateComment(Comment comment);

  // Remove a star from a prompt (returns the updated prompt with decremented stars)
  Future<void> removePromptStar(String promptId);

  // Upvote an answer (returns the updated prompt with the answer's upvotes incremented)
  Future<void> upvoteAnswer(String promptId, String answerId);

  // Downvote an answer (returns the updated prompt with the answer's downvotes incremented)
  Future<void> downvoteAnswer(String promptId, String answerId);

  // Add an answer or a list of answers to a prompt (returns the updated prompt with the new answers)
  Future<void> postAnswer(String promptId, List<Answer> answers);

  // Fetch more prompts from a specific owner for pagination (returns a stream of a list of prompts)
  Future<void> fetchMorePromptFromOwner(String ownerId, int page);

  // Remove a prompt by ID (returns void)
  Future<void> removePrompt(String? promptId);

  // Remove an answer by ID (returns the updated prompt with the answer removed)
  Future<void> removeAnswer(String promptId, String answerId);

  // Update an answer by ID (returns the updated prompt with the updated answer)
  Future<void> updateAnswer(String promptId, String answerId, Answer updatedAnswer);

  Future<void> getCurrentUser();
}