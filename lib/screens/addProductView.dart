import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/productProvider.dart';

class AddProdutc extends StatefulWidget {
  static final String routeName = "/addProducts";
  @override
  _EditProdutcState createState() => _EditProdutcState();
}

class _EditProdutcState extends State<AddProdutc> {
  final priceFocus = FocusNode();
  final imageController = TextEditingController();
  final imageUrlFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  Product newProduct =
      new Product(id: "", title: "", description: "", imageUrl: "", price: 0.0);
  bool isLoading = false;
  @override
  void initState() {
    imageUrlFocus.addListener(updateUI);
    super.initState();
  }

  void dispose() {
    imageUrlFocus.removeListener(updateUI);
    priceFocus.dispose();
    imageController.dispose();
    imageUrlFocus.dispose();
    super.dispose();
  }

  void updateUI() {
    if (!imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() async{
    formKey.currentState!.validate();
    formKey.currentState!.save();
    setState(() {
      isLoading=true;
    });
   await  Provider.of<ProductProvider>(context, listen: false)
        .addProduct(this.newProduct).catchError((error){
         return showDialog(context: context, builder: (ctx){
            return AlertDialog(title: Text("An error occurred"),
            content: Text("Something went wrong"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
            );
          });
        }).then((value) {
          setState(() {
            isLoading=false;
          });
    Navigator.of(context).pop();
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body:isLoading?Center(child: CircularProgressIndicator(),): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text("Title"),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocus);
                },
                onSaved: (value) {
                  newProduct.title = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please provide a value";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text("Price"),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: this.priceFocus,
                onSaved: (value) {
                  newProduct.price = double.parse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return " this field cann't be empty";
                  } else if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return "please enter a valid price";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text("Description"),
                  errorStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) {
                  newProduct.description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return " this field cann't be empty";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 5, right: 5),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: imageController.text.isEmpty
                        ? Text("Enter Image Url")
                        : FittedBox(
                            child: Image.network(imageController.text),
                            fit: BoxFit.fill,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text("Image URL"),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageController,
                      onFieldSubmitted: (_) {
                        //saveForm();
                        setState(() {});
                      },
                      focusNode: imageUrlFocus,
                      onSaved: (value) {
                        newProduct.imageUrl = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return " please enter an image url";
                        } else if ((!value.startsWith('http') &&
                            !value.startsWith('https'))) {
                          return " please enter a valid url";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
