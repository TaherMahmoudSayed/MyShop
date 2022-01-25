import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/productProvider.dart';
import 'package:shopapp/screens/cartReview.dart';
import 'package:shopapp/widgets/appDrawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/productsGrid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showFavorites = false, isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading=true;
    });
    Provider.of<ProductProvider>(context, listen: false).fetchProducts().then((value) {
      setState(() {
        isLoading=false;
      });
    }).catchError((e){
       setState(() {
        isLoading=false;
      showDialog(context: context, builder: (ctx){
        return AlertDialog(title: Text("An error occurred"),
            content: Text("Something went wrong"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
            );
            
      });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop App'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Show Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch != null
                  ? ch
                  : IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.shopping_cart),
                    ),
              textValue: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartReview.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading?Center(child: CircularProgressIndicator(),): ProductsGrid(favoriteStates: _showFavorites),
    );
  }
}
