import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/appDrawer.dart';
import 'package:shopapp/widgets/orderListItem.dart';

class OrderReview extends StatefulWidget {
  static final String routeName = "/orders";

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .fetchOrders()
        .then((value) { 
          
         setState(() {
      isLoading = false;
    });});
  }

  @override
  Widget build(BuildContext context) {
    var OrderProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawer(),
      body:isLoading?Center(child: CircularProgressIndicator(),): ListView.builder(
        itemBuilder: (ctx, i) => OrderListItem(OrderProvider.orders[i]),
        itemCount: OrderProvider.orders.length,
      ),
    );
  }
}
