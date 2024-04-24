import 'dart:convert';

class MovieM {
List<Movie> movieList = [];
 // List<ResidenteModel> residenteListbyUser = [];

  MovieM.fromJsonList(json) {
   
    if (json == null) {
      return;
    } else {
      json.forEach((key, val) {
        if (json is Map<String, dynamic>) {
         // print("e");
          try {
            //print("try");
            final value = Movie.fromMap(val);
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
   String? title;
   String? director;
   String? imageUrl;
   String? description;
   String? horario;
   String? categories;
  bool? isFavorite;
  String? review;
  Movie({
    this.id,
    this.title,
    this.director,
    this.imageUrl,
    this.description,
    this.horario,
    this.categories,
    this.isFavorite,
    this.review,
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

  factory Movie.fromMap(Map<String, dynamic>map) {
    
    print('Movie  $Movie.');
    return Movie(
      description: map['description']??'',
      director: map['director'] ??'',
      horario: map['horario'] ,
      imageUrl: map['imageUrl'] ,
      isFavorite: map['isFavorite'] ,
      review: map['review'] ,
      title: map['title'],
      categories:  map['categories']??'',
      
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movie(title: $title, director: $director, imageUrl: $imageUrl, description: $description, horario: $horario, categories: $categories, isFavorite: $isFavorite, review: $review)';
  }
}
