import 'interest.dart';
import 'comment.dart';
import 'answer.dart';
import 'prompt.dart';
import 'user.dart';

class ModelFactory {
  // Factory method to create a User instance
  static User createUser({
    String? id, // id is optional
    required DateTime createdDate,
    required DateTime lastModifiedDate,
    List<Interest> interests = const [],
    required String alias,
    required String pictureUrl,
  }) {
    return User(
      id: id,
      createdDate: createdDate,
      lastModifiedDate: lastModifiedDate,
      interests: interests,
      alias: alias,
      pictureUrl: pictureUrl,
    );
  }

  // Factory method to create an Answer instance
  static Answer createAnswer({
    String? id, // id is optional
    required String content,
    required String source,
    required String category,
    int upvotes = 0,
    int downvotes = 0,
    required String ownerId,
  }) {
    return Answer(
      id: id,
      content: content,
      source: source,
      category: category,
      upvotes: upvotes,
      downvotes: downvotes,
      ownerId: ownerId,
    );
  }

  // Factory method to create a Comment instance
  static Comment createComment({
    String? id, // id is optional
    required String uuid,
    required DateTime createdDate,
    required DateTime lastModifiedDate,
    required String content,
    required int stars,
    required String ownerId,
  }) {
    return Comment(
      id: id,
      createdDate: createdDate,
      lastModifiedDate: lastModifiedDate,
      content: content,
      stars: stars,
      ownerId: ownerId,
    );
  }

  // Factory method to create an Interest instance
  static Interest createInterest({
    String? id, // id is optional
    required String keyword,
    double score = 0.0,
  }) {
    return Interest(
      id: id,
      keyword: keyword,
      score: score,
    );
  }

  // Factory method to create a Prompt instance
  static Prompt createPrompt({
    String? id, // id is optional
    required String content,
    required String ownerId,
    required String ownerAlias,
    required String ownerPictureUrl,
    required DateTime createdDate,
    required DateTime lastModifiedDate,
    List<Comment> comments = const [],
    int stars = 0,
    List<Answer> aiAnswers = const [],
  }) {
    return Prompt(
      id: id,
      content: content,
      ownerId: ownerId,
      ownerAlias: ownerAlias,
      ownerPictureUrl: ownerPictureUrl,
      createdDate: createdDate,
      lastModifiedDate: lastModifiedDate,
      comments: comments,
      stars: stars,
      aiAnswers: aiAnswers,
    );
  }
}