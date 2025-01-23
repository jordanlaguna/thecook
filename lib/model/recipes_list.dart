class Recipe {
  final String author;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  bool isFavorite;
  bool liked;

  Recipe({
    required this.name,
    required this.author,
    required this.imageUrl,
    required this.ingredients,
    this.isFavorite = false,
    this.liked = false,
  });
}
