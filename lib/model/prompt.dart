import 'package:equatable/equatable.dart';

import 'comment.dart';
import 'answer.dart';

class Prompt extends Equatable {
  final String? id;
  final String content;
  final String ownerId; // Changed back to String
  final String ownerAlias; // Alias of the owner
  final String ownerPictureUrl; // Profile picture URL of the owner
  final DateTime createdDate;
  final DateTime lastModifiedDate;
  final List<Comment> comments;
  final int stars; // Stars field with default value of 0
  final List<Answer> aiAnswers; // List of AI answers

  // Constructor with default values for stars and aiAnswers
  const Prompt({
    this.id,
    required this.content,
    required this.ownerId, // Now a String
    required this.ownerAlias, // Owner alias is required
    required this.ownerPictureUrl, // Owner picture URL is required
    required this.createdDate,
    required this.lastModifiedDate,
    this.comments = const [], // Initialize an empty list if no comments are provided
    this.stars = 0, // Default value of 0 for stars
    this.aiAnswers = const [], // Initialize an empty list if no AI answers are provided
  });

  // Named constructor for creating a Prompt from JSON
  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'],
      content: json['content'],
      ownerId: json['ownerId'], // Now a String
      ownerAlias: json['ownerAlias'], // Parse ownerAlias from JSON
      ownerPictureUrl: json['ownerPictureUrl'], // Parse ownerPictureUrl from JSON
      createdDate: DateTime.parse(json['createdDate']),
      lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      stars: json['stars'] ?? 0, // Default to 0 if stars is not present in JSON
      aiAnswers: (json['aiAnswers'] as List<dynamic>?)
              ?.map((answer) => Answer.fromJson(answer))
              .toList() ??
          [], // Parse AI answers
    );
  }

  // Method to convert a Prompt to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'ownerId': ownerId, // Now a String
      'ownerAlias': ownerAlias, // Include ownerAlias in JSON
      'ownerPictureUrl': ownerPictureUrl, // Include ownerPictureUrl in JSON
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'stars': stars, // Include stars in the JSON serialization
      'aiAnswers': aiAnswers.map((answer) => answer.toJson()).toList(), // Include AI answers in the JSON serialization
    };
  }

  // CopyWith method for immutability
  Prompt copyWith({
    String? id,
    String? content,
    String? ownerId, // Now a String
    String? ownerAlias, // Allow modification of ownerAlias
    String? ownerPictureUrl, // Allow modification of ownerPictureUrl
    DateTime? createdDate,
    DateTime? lastModifiedDate,
    List<Comment>? comments,
    int? stars, // Allow modification of stars
    List<Answer>? aiAnswers, // Allow modification of AI answers
  }) {
    return Prompt(
      id: id ?? this.id,
      content: content ?? this.content,
      ownerId: ownerId ?? this.ownerId, // Now a String
      ownerAlias: ownerAlias ?? this.ownerAlias, // Use the new value for ownerAlias if provided
      ownerPictureUrl: ownerPictureUrl ?? this.ownerPictureUrl, // Use the new value for ownerPictureUrl if provided
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      comments: comments ?? this.comments,
      stars: stars ?? this.stars, // Use the new value for stars if provided
      aiAnswers: aiAnswers ?? this.aiAnswers, // Use the new value for AI answers if provided
    );
  }

  @override
  String toString() {
    return 'Prompt(id: $id, content: $content, ownerId: $ownerId, ownerAlias: $ownerAlias, ownerPictureUrl: $ownerPictureUrl, createdDate: $createdDate, lastModifiedDate: $lastModifiedDate, comments: $comments, stars: $stars, aiAnswers: $aiAnswers)';
  }

  @override
  List<Object?> get props => [id, content, ownerId, ownerAlias, ownerPictureUrl, createdDate, lastModifiedDate, comments, stars, aiAnswers];
}