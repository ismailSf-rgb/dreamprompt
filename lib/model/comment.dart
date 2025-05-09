import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String? id;
  final DateTime createdDate;
  final DateTime lastModifiedDate;
  final String content;
  final int stars;
  final String ownerId;

  // Constructor
  const Comment({
    this.id,
    required this.createdDate,
    required this.lastModifiedDate,
    required this.content,
    required this.stars,
    required this.ownerId,
  });

  // Named constructor for creating a Comment from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      createdDate: DateTime.parse(json['createdDate']),
      lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
      content: json['content'],
      stars: json['stars'],
      ownerId: json['ownerId'],
    );
  }

  // Method to convert a Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'content': content,
      'stars': stars,
      'ownerId': ownerId,
    };
  }

  // CopyWith method for immutability
  Comment copyWith({
    String? id,
    DateTime? createdDate,
    DateTime? lastModifiedDate,
    String? content,
    int? stars,
    String? ownerId,
  }) {
    return Comment(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      content: content ?? this.content,
      stars: stars ?? this.stars,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, createdDate: $createdDate, lastModifiedDate: $lastModifiedDate, content: $content, stars: $stars, ownerId: $ownerId)';
  }

  @override
  List<Object?> get props => [id, createdDate, lastModifiedDate, content, stars, ownerId];
}
