import 'package:equatable/equatable.dart';

class Answer extends Equatable {
  final String? id; // Unique identifier for the answer
  final String content; // The content of the answer
  final String source; // The source of the answer (e.g., OpenAI, DeepSeek)
  final String category; // The category of the answer (e.g., code, mathematics, physics)
  final int upvotes; // Number of upvotes
  final int downvotes; // Number of downvotes
  final String ownerId; // Identifier for the user posting the answer

  // Constructor
  const Answer({
    this.id,
    required this.content,
    required this.source,
    required this.category,
    this.upvotes = 0, // Default value of 0 for upvotes
    this.downvotes = 0, // Default value of 0 for downvotes
    required this.ownerId, // ownerId is required
  });

  // Named constructor for creating an Answer from JSON
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      content: json['content'],
      source: json['source'],
      category: json['category'],
      upvotes: json['upvotes'] ?? 0, // Default to 0 if upvotes is not present in JSON
      downvotes: json['downvotes'] ?? 0, // Default to 0 if downvotes is not present in JSON
      ownerId: json['ownerId'], // Parse ownerId from JSON
    );
  }

  // Method to convert an Answer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'source': source,
      'category': category,
      'upvotes': upvotes, // Include upvotes in the JSON serialization
      'downvotes': downvotes, // Include downvotes in the JSON serialization
      'ownerId': ownerId, // Include ownerId in the JSON serialization
    };
  }

  // CopyWith method for immutability
  Answer copyWith({
    String? id,
    String? content,
    String? source,
    String? category,
    int? upvotes, // Allow modification of upvotes
    int? downvotes, // Allow modification of downvotes
    String? ownerId, // Allow modification of ownerId
  }) {
    return Answer(
      id: id ?? this.id,
      content: content ?? this.content,
      source: source ?? this.source,
      category: category ?? this.category,
      upvotes: upvotes ?? this.upvotes, // Use the new value for upvotes if provided
      downvotes: downvotes ?? this.downvotes, // Use the new value for downvotes if provided
      ownerId: ownerId ?? this.ownerId, // Use the new value for ownerId if provided
    );
  }

  @override
  String toString() {
    return 'Answer(id: $id, content: $content, source: $source, category: $category, upvotes: $upvotes, downvotes: $downvotes, ownerId: $ownerId)';
  }

  @override
  List<Object?> get props => [id, content, source, category, upvotes, downvotes, ownerId];
}