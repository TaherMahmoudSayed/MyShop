import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/productProvider.dart';
import 'package:shopapp/screens/productDetails.dart';

class ProductItem extends StatelessWidget {
  final Product productItem;
  final random = Random();
  ProductItem({required this.productItem}) {}
  final colors = [Colors.orange, Colors.blue, Colors.black26];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // child: GestureDetector(
        //   onTap: () => {
        //     Navigator.of(context).pushNamed(ProductDetails.routeName,
        //         arguments: this.productItem),
        //   },
        child: Hero(
          tag: productItem.id,
          child: FadeInImage(
            placeholder: AssetImage("assets/6.2 product-placeholder.png"),
            image: NetworkImage(
              this.productItem.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
        ),
        //),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(productItem.isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              productProvider
                  .toggelFavorite(this.productItem)
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              });
            },
          ),
          title: GestureDetector(
              onTap: () => {
                    Navigator.of(context).pushNamed(ProductDetails.routeName,
                        arguments: this.productItem),
                  },
              child: Text(
                this.productItem.title,
                textAlign: TextAlign.center,
              )),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItem(this.productItem.id, this.productItem.title,
                  this.productItem.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added item to cart"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cartProvider.decreaseItem(productItem.id);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
