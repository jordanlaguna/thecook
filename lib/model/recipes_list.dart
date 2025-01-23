class Recipe {
  final String author;
  final String name;
  final double calificacion;
  final String imageUrl;
  final List<String> ingredientes;
  bool isFavorite;
  bool liked;

  Recipe({
    required this.author,
    required this.name,
    required this.calificacion,
    required this.imageUrl,
    required this.ingredientes,
    this.isFavorite = false,
    this.liked = false,
  });
}
