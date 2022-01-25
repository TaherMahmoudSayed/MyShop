import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;
  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    print(" Cart.dart/ itemcount:" + _items.length.toString());
    return _items.length;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  CartItem? removeItem(String productId) {
    CartItem? item = _items.remove(productId);
    if (item != null) {
      notifyListeners();
      return item;
    } else
      return null;
  }

  void decreaseItem(String productId) {
    var item = _items[productId];
    if (item != null && item.quantity > 1) {
      item.quantity -= 1;
      _items.update(productId, (value) => item);
    } else {
      this.removeItem(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
