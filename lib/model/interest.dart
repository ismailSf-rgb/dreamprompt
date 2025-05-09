import 'package:equatable/equatable.dart';

class Interest extends Equatable {
  final String? id; // Unique identifier for the interest
  final String keyword; // The keyword representing the interest (e.g., "Flutter", "Dart")
  final double score; // A numeric value representing the user's level of interest or relevance

  // Constructor
  const Interest({
    this.id,
    required this.keyword,
    this.score = 0.0, // Default value for score
  });

  // Named constructor for creating an Interest from JSON
  factory Interest.fromJson(Map<String, dynamic> json) {
    try {
      return Interest(
        id: json['id'],
        keyword: json['keyword'],
        score: (json['score'] as num).toDouble(), // Ensure score is a double
      );
    } catch (e) {
      throw FormatException('Failed to parse Interest from JSON: $e');
    }
  }

  // Method to convert an Interest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyword': keyword,
      'score': score,
    };
  }

  // CopyWith method for immutability
  Interest copyWith({
    String? id,
    String? keyword,
    double? score,
  }) {
    return Interest(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      score: score ?? this.score,
    );
  }

  @override
  String toString() {
    return 'Interest(id: $id, keyword: $keyword, score: $score)';
  }

  @override
  List<Object?> get props => [id, keyword, score];

}