import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/productProvider.dart';
import 'package:shopapp/widgets/productItem.dart';

class ProductsGrid extends StatelessWidget {
  final bool favoriteStates;
  ProductsGrid({required this.favoriteStates});

  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<ProductProvider>(context);
    List<Product> productItems = favoriteStates?productData.FavoritesItems: productData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: productItems.length,
      itemBuilder: (ctx, i) => ProductItem(productItem: productItems[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
