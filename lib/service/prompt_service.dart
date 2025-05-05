import 'dart:async';
import '../model/comment.dart';
import '../model/prompt.dart';
import '../model/answer.dart';

abstract class PromptService {

  // Fetch a single prompt by ID (returns a stream of Prompt)
  Stream<Prompt> fetchPrompt(String id, String userId);

  // Fetch all prompts (returns a stream of a list of prompts)
  Stream<List<Prompt>> fetchAllPrompts(String userId);

  // Fetch more prompts for pagination (returns a stream of a list of prompts)
  Stream<List<Prompt>> fetchMorePrompts(int page, String userId);

  // Create a new prompt (returns the newly created prompt)
  Future<Prompt> postPrompt(Prompt prompt);

  // Add a comment to a prompt by ID (returns the updated prompt with the new comment)
  Stream<Prompt> addCommentToPrompt(String promptId, Comment comment);

  // Increment stars for a prompt (returns the updated prompt with incremented stars)
  Stream<Prompt> incrementPromptStars(String promptId);

    // Update an existing prompt (returns the updated prompt)
  Stream<Prompt> updatePrompt(Prompt prompt);

  // Update an existing comment (returns the updated comment)
  Stream<Comment> updateComment(Comment comment);

  // Remove a star from a prompt (returns the updated prompt with decremented stars)
  Stream<Prompt> removePromptStar(String promptId);

  // Upvote an answer (returns the updated prompt with the answer's upvotes incremented)
  Stream<Prompt> upvoteAnswer(String promptId, String answerId);

  // Downvote an answer (returns the updated prompt with the answer's downvotes incremented)
  Stream<Prompt> downvoteAnswer(String promptId, String answerId);

  // Add an answer or a list of answers to a prompt (returns the updated prompt with the new answers)
  Stream<Prompt> postAnswer(String promptId, List<Answer> answers);

  // Fetch more prompts from a specific owner for pagination (returns a stream of a list of prompts)
  Stream<List<Prompt>> fetchMorePromptFromOwner(String ownerId, int page);

  // Remove a prompt by ID (returns void)
  Future<void> removePrompt(String promptId);

  // Remove an answer by ID (returns the updated prompt with the answer removed)
  Stream<Prompt> removeAnswer(String promptId, String answerId);

  // Update an answer by ID (returns the updated prompt with the updated answer)
  Stream<Prompt> updateAnswer(String promptId, String answerId, Answer updatedAnswer);
}
