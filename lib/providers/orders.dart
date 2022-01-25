import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  String token = "";
  String userId = "";

  List<OrderItem> get getOrders {
    return [...orders];
  }

  Orders({String? token, List<OrderItem>? orders, String? userID}) {
    this.token = token == null ? "" : token;
    this.orders = orders == null ? [] : orders;
    this.userId = userID == null ? "" : userID;
  }

  Future<void> fetchOrders() {
    print("enterd fetch orders");
    final url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token");
    return http.get(url).then((response) {
      print("orders response:"+json.decode(response.body).toString());
       if (response.statusCode != 200 && response.body == "null") {
         print("null orders response");
         return;
       }
      if (response.statusCode == 200 && response.body != "null") {
        var extractedData = json.decode(response.body) as Map<String, dynamic>;
        

        List<OrderItem> fetchedOrders = [];
        extractedData.forEach((orderId, orderData) {
          fetchedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title']),
                  )
                  .toList(),
            ),
          );
        });
        orders = fetchedOrders.reversed.toList();
        notifyListeners();
        
      }
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) {
    final url = Uri.parse(
        "https://testshop-22dac-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token");
    final currentTime = DateTime.now();
    return http
        .post(url,
            body: json.encode({
              "amount": totalAmount,
              "dateTime": currentTime.toIso8601String(),
              "products": cartProducts
                  .map((cp) => {
                        "id": cp.id,
                        "title": cp.title,
                        "price": cp.price,
                        "quantity": cp.quantity,
                      })
                  .toList(),
            }))
        .then((response) {
      orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: totalAmount,
              dateTime: DateTime.now(),
              products: cartProducts));
      notifyListeners();
    }).catchError((onError) => throw onError);
  }
}
