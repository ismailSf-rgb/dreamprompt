import 'interest.dart';
import 'package:collection/collection.dart';

class User {
  final String? id; // Unique string identifier for the user
  final DateTime createdDate; // Timestamp for when the user was created
  final DateTime lastModifiedDate; // Timestamp for when the user was last modified
  final List<Interest> interests; // List of the user's interests
  final String alias; // User's alias (nickname or display name)
  final String pictureUrl; // URL to the user's profile picture

  // Constructor
  User({
    this.id,
    required this.createdDate,
    required this.lastModifiedDate,
    this.interests = const [], // Default value for interests
    required this.alias, // Alias is required
    required this.pictureUrl, // Picture URL is required
  });

  // Named constructor for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Parse the list of interests from JSON
      final interestsJson = json['interests'] as List? ?? [];
      final interestsList = interestsJson.map((i) => Interest.fromJson(i)).toList();

      return User(
        id: json['id'],
        createdDate: DateTime.parse(json['createdDate']),
        lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
        interests: interestsList,
        alias: json['alias'], // Parse alias from JSON
        pictureUrl: json['pictureUrl'], // Parse pictureUrl from JSON
      );
    } catch (e) {
      throw FormatException('Failed to parse User from JSON: $e');
    }
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'interests': interests.map((i) => i.toJson()).toList(), // Convert interests to JSON
      'alias': alias, // Include alias in JSON
      'pictureUrl': pictureUrl, // Include pictureUrl in JSON
    };
  }

  // CopyWith method for immutability
  User copyWith({
    String? id,
    DateTime? createdDate,
    DateTime? lastModifiedDate,
    List<Interest>? interests,
    String? alias, // Allow modification of alias
    String? pictureUrl, // Allow modification of pictureUrl
  }) {
    return User(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      interests: interests ?? this.interests,
      alias: alias ?? this.alias, // Use the new value for alias if provided
      pictureUrl: pictureUrl ?? this.pictureUrl, // Use the new value for pictureUrl if provided
    );
  }

  @override
  String toString() {
    return 'User(id: $id,createdDate: $createdDate, lastModifiedDate: $lastModifiedDate, interests: $interests, alias: $alias, pictureUrl: $pictureUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.createdDate == createdDate &&
        other.lastModifiedDate == lastModifiedDate &&
        const ListEquality().equals(other.interests, interests) &&
        other.alias == alias && // Compare alias field
        other.pictureUrl == pictureUrl; // Compare pictureUrl field
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdDate.hashCode ^
        lastModifiedDate.hashCode ^
        interests.hashCode ^
        alias.hashCode ^ // Include alias in hashCode calculation
        pictureUrl.hashCode; // Include pictureUrl in hashCode calculation
  }
}