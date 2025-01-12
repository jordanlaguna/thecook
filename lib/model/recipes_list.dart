class Recipe {
  final String name;
  final double calificacion;
  final String imageUrl;
  final List<String> ingredientes;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.calificacion,
    required this.imageUrl,
    required this.ingredientes,
    this.isFavorite = false,
  });
}
