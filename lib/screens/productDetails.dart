import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/productProvider.dart';

class ProductDetails extends StatelessWidget {
  static String routeName = "/productDetails";

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                child: Hero(tag: product.id,child: Image.network(product.imageUrl)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "\$${product.price}",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "\$${product.description}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
