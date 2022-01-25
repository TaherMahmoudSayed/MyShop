import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/productProvider.dart';
import 'package:shopapp/screens/addProductView.dart';
import 'package:shopapp/widgets/appDrawer.dart';
import 'package:shopapp/widgets/userProductItem.dart';

class UserProductView extends StatelessWidget {
  static final String routeName = "/userProducts";

  Future<void> pullProducts(BuildContext ctx) async {
    try {
      print("entered pullProducts User Productd view"); ///////////////////////

      await Provider.of<ProductProvider>(ctx, listen: false)
          .fetchProducts(true);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    //var productProvider = Provider.of<ProductProvider>(context);
    print("entered build User Productd view"); ///////////////////////

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProdutc.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: pullProducts(context),
        builder: (ctx, snapsShot) => snapsShot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<ProductProvider>(
                builder: (ctx, productProvider, _) => RefreshIndicator(
                  onRefresh: () => pullProducts(context),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: productProvider.myItems.length == 0
                        ? Center(
                            child: TextButton(
                              child: Text("You have No Products yet, Reload!"),
                              onPressed: () async {
                                await pullProducts(context);
                              },
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, i) => Column(
                              children: [
                                UserProductItem(productProvider.myItems[i]),
                                Divider(),
                              ],
                            ),
                            itemCount: productProvider.myItems.length,
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
