import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cartListItem.dart';

class CartReview extends StatelessWidget {
  static String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  FittedBox(
                    child: Chip(
                      label: Text(
                        '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  OrderButton(cartProvider: cartProvider)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.itemCount,
              itemBuilder: (ctx, i) => CartListItem(
                  cartProvider.items.keys.toList()[i],
                  cartProvider.items.values.toList()[i].id,
                  cartProvider.items.values.toList()[i].title,
                  cartProvider.items.values.toList()[i].price,
                  cartProvider.items.values.toList()[i].quantity),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:(widget.cartProvider.items.values.toList().length==0|| isLoading)?null: () {
        setState(() {
          isLoading=true;
        });
        Provider.of<Orders>(context,listen: false).addOrder(
            widget.cartProvider.items.values.toList(),
            widget.cartProvider.totalPrice).then((value) {
              setState(() {
                isLoading=false;
              });
            widget.cartProvider.clear();

            });
      },
      child: isLoading?Center(child: CircularProgressIndicator(),): Text(  
        'ORDER NOW!',
        style: TextStyle(fontSize: 15,color:  Theme.of(context).primaryColor,),

      ),
      
    );
  }
}
