import 'dart:convert';


class Movie {
  final String title;
  final String director;
  final String imageUrl;
  final String description;
  final String horario;
  final List<String> categories;
  bool isFavorite;
  String review;

  Movie({
    required this.title,
    required this.director,
    required this.imageUrl,
    required this.description,
    required this.horario,
    this.categories = const [],
    this.isFavorite = false,
    this.review = '',
  });

  Movie copyWith({
    String? title,
    String? director,
    String? imageUrl,
    String? description,
    String? horario,
    List<String>? categories,
    bool? isFavorite,
    String? review,
  }) {
    return Movie(
      title: title ?? this.title,
      director: director ?? this.director,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      horario: horario ?? this.horario,
      categories: categories ?? this.categories,
      isFavorite: isFavorite ?? this.isFavorite,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'director': director,
      'imageUrl': imageUrl,
      'description': description,
      'horario': horario,
      'categories': categories,
      'isFavorite': isFavorite,
      'review': review,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      horario: map['horario'] ?? '',
      categories: List<String>.from(map['categories']),
      isFavorite: map['isFavorite'] ?? false,
      review: map['review'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movie(title: $title, director: $director, imageUrl: $imageUrl, description: $description, horario: $horario, categories: $categories, isFavorite: $isFavorite, review: $review)';
  }
}
