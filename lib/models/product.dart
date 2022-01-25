import 'package:provider/provider.dart';

class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});
  
}
