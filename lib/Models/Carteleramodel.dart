import 'dart:convert';


class MovieM {
List<Movie> movieList = [];
 // List<ResidenteModel> residenteListbyUser = [];

  MovieM.fromJsonList(json) {
    print(json);
    if (json == null) {
      return;
    } else {
      json.forEach((key, val) {
        if (json is Map<String, dynamic>) {
         // print("e");
          try {
            //print("try");
            final value = Movie.fromMap(json as Map<String, dynamic>);
            value.id = key;
            movieList.add(value);
          } catch (e) {
            throw new Exception(e);
          }
        }
      });
    }
  }
}
class Movie {
   String? id;
   String title;
   String director;
   String imageUrl;
   String description;
   String horario;
   String categories;
  bool isFavorite;
  String review;

Movie({
  required this.title,
  required this.director,
  required this.imageUrl,
  required this.description,
  required this.horario,
  required this.categories ,
  this.isFavorite = false,
  this.review = '',
  this.id, 
});



  Map<String, dynamic> toMap() {
    return {
       'id':id,
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
    //print("Despues from map");
    return Movie(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      horario: map['horario'] ?? '',
      categories: map['categories']??'',
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
