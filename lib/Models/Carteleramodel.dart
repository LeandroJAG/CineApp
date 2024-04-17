class carteleraModel {
  final String title;
  final String director;
  final String imageUrl;
  final String description;
  final String horario;
  final List<String> categories;
  bool isFavorite;
  String review;

  carteleraModel({
    required this.title,
    required this.director,
    required this.imageUrl,
    required this.description,
    required this.horario,
    this.categories = const [],
    this.isFavorite = false,
    this.review = '',
  })
  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "director" : director,
      "imagenUrl" : imageUrl,
      "description" : description,
      "horario" : horario,
      "categories" : categories,
      "isFavorite" : isFavorite,
      "review" : review,
      
         };
  }
  }