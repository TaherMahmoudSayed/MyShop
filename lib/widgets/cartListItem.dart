import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartListItem(this.productId, this.id, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete_forever,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
             return AlertDialog(
                title: Text("Confirmation"),
                content: Text("Do you want to remove the item from the cart"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Yes")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No")),
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(this.productId);
      },
      child: Card(
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    '\$${this.price}',
                  ),
                ),
              ),
            ),
            title: Text(this.title),
            subtitle: Text("Total: \$${this.price * this.quantity}"),
            trailing: FittedBox(
              alignment: Alignment.centerRight,
              fit: BoxFit.fill,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${this.quantity} x",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .addItem(productId, title, price);
                          },
                          icon: Icon(Icons.add),
                          color: Colors.red,
                          iconSize: 30,
                          padding: EdgeInsets.all(0),
                        ),
                        IconButton(
                          onPressed: () {
                            DismissDirection.endToStart;
                            Provider.of<Cart>(context, listen: false)
                                .decreaseItem(productId);
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.red,
                          iconSize: 30,
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
