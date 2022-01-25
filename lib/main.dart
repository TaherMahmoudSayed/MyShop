import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/productProvider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cartReview.dart';
import 'package:shopapp/screens/addProductView.dart';
import 'package:shopapp/screens/ordersView.dart';
import 'package:shopapp/screens/productDetails.dart';
import 'package:shopapp/screens/product_overview.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/userProductsView.dart';
import 'screens/editProductView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
            create: (ctx) => ProductProvider(),
            update: (ctx, auth, previousProduct) => ProductProvider(
                token: auth.token(),
                userID: auth.userId,
                items: previousProduct!.items.length == 0
                    ? []
                    : previousProduct.items)),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrder) => Orders(
            token: auth.token(),
            orders:
                previousOrder!.orders.length == 0 ? [] : previousOrder.orders,
            userID: auth.userId,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authProvider, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            primaryTextTheme:
                TextTheme(bodyText1: TextStyle(color: Colors.white)),
            accentColor: Colors.orange,

            //fontFamily: 'Anton'
          ),
          home: authProvider.isAuthenticated
              ? ProductOverview()
              : FutureBuilder<bool>(
                  future: authProvider.tryLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartReview.routeName: (ctx) => CartReview(),
            OrderReview.routeName: (ctx) => OrderReview(),
            UserProductView.routeName: (ctx) => UserProductView(),
            EditProduct.routeName: (ctx) => EditProduct(),
            AddProdutc.routeName: (ctx) => AddProdutc(),
          },
        ),
      ),
    );
  }
}
