import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shopapp/models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  static int count = 0;
  String token = "";
  Uri url = new Uri();
  List<Product> _items = [];
  List<Product> _MyItems = [];
  String userId = "";

  ProductProvider({String? token, String? userID, List<Product>? items}) {
    print("--------------------------------------");
    print('Product provider has been created' + count.toString());
    count++;
    this.token = token == null ? "" : token;
    this._items = items == null ? [] : items;
    this.userId = userID == null ? "" : userID;
    url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com/products.json?auth=$token");
  }
  List<Product> get items {
    print("product items:" + _items.length.toString());
    return [..._items];
  }

  List<Product> get myItems {
    print("product items:" + _items.length.toString());
    return [..._MyItems];
  }

  Product getById(var id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts([bool filterByUserId = false]) async {
    try {
      print("enterd fetchProduct and value=" + filterByUserId.toString());
      String filterQuery =
          filterByUserId ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      print(filterQuery);
      final response = await http.get(Uri.parse(
          'https://testshop-22dac-default-rtdb.firebaseio.com/products.json?auth=$token&$filterQuery'));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.values.length == 0) {
        print("exctracted data=0");
        return;
      }
      final List<Product> loadedProducts = [];
      print("count of products:" + extractedData.values.length.toString());
      final url = Uri.parse(
          "https://testshop-22dac-default-rtdb.firebaseio.com//userFavorites/$userId.json?auth=$token");
      var favoriteResponse = await http.get(url);
      var favoriteData;
      print("favorite response:" + favoriteResponse.body);
      if (favoriteResponse.body == "null") {
        print("entered null check");
        favoriteData = {};
      } else {
        print("entered else check");

        favoriteData =
            json.decode(favoriteResponse.body) as Map<String, dynamic>;
      }

      print("count of favorites products:" +
          favoriteData.values.length.toString());

      extractedData.forEach((key, value) {
        // print(favoriteData.keys);
        // print(favoriteData[key]["isFavorite"]);

        loadedProducts.add(new Product(
          id: key,
          title: value["title"],
          description: value["description"],
          imageUrl: value["imageUrl"],
          price: value["price"],
          isFavorite: favoriteData[key] != null
              ? favoriteData[key]["isFavorite"]
              : false,
        ));
      });
      filterByUserId ? _MyItems = loadedProducts : _items = loadedProducts;
      //_items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    return http
        .post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'creatorId': this.userId,
            }))
        .then((value) async {
      product.id = jsonDecode(value.body)['name'];
      print("product ID : " + product.id);
      _items.add(product);
      await Future.delayed(Duration(seconds: 10));
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> toggelFavorite(Product product) {
    bool oldStatus = product.isFavorite;
    String id = product.id;
    final url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com//userFavorites/$userId/$id.json?auth=$token");
    product.isFavorite = !product.isFavorite;
    return http
        .put(url, body: json.encode({"isFavorite": product.isFavorite}))
        .then((response) {
      if (response.statusCode != 200) {
        product.isFavorite = oldStatus;
        throw Exception("Faild to Update");
      }
      notifyListeners();
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> updateProduct(Product product) {
    String id = product.id;
    print("Updat function" + product.title.toString());
    var productIndex = _items.indexWhere((prod) => prod.id == product.id);
    if (productIndex >= 0) {
      _items[productIndex] = product;
    }
    final url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com/products/$id.json?auth=$token");
    return http
        .patch(url,
            body: json.encode(
              {
                "title": product.title,
                "description": product.description,
                "price": product.price,
                "imageUrl": product.imageUrl,
                "creatorId": this.userId,
              },
            ))
        .then((value) {
      var productIndex = _items.indexWhere((prod) => prod.id == product.id);
      if (productIndex >= 0) {
        _items[productIndex] = product;
        notifyListeners();
      } else
        print("not found");
    });
  }

  Future<void> deleteProduct(String id) {
    final url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com/products/$id.json?auth=$token");
    var productIndex = _items.indexWhere((element) => element.id == id);
    Product? deletedProduct = _items[productIndex];
    _items.removeAt(productIndex);
    return http.delete(url).then((response) {
      if (response.statusCode == 200) {
        deletedProduct = null;
        notifyListeners();
      } else {
        _items.insert(productIndex, deletedProduct!);
        notifyListeners();
        throw Exception("Couldn't delete the Product");
      }
    });
  }

  List<Product> get FavoritesItems {
    return [..._items].where((element) => element.isFavorite).toList();
  }
}
