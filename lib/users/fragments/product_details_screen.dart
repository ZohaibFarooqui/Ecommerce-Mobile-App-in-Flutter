import 'package:flutter/material.dart';
import 'package:ecommerce/users/fragments/product.dart';
import 'package:ecommerce/mysql.dart';
import 'package:ecommerce/users/fragments/wishlist_fragment_screen.dart';
import 'package:get/get.dart';
import '../userPreferences/current_user.dart';
import 'Cart.dart';
import 'favorites.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;

  Future<void> addToCart() async {
    try {
      // Convert Product to CartItem
      CartItem cartItem = CartItem(
        userId: widget._rememberCurrentUser.user.user_id,
        productId: widget.product.productId,
        quantity: 1,
        price: widget.product.price.toDouble(),
        cusAddress: '',
        cusPhoneNo: 0,
      );

      // Call the existing addToCart function
      await Mysql().addToCart(cartItem);
      print('Product added to cart successfully!');
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> addToFavorites() async {
    try {
      // Convert Product to FavoritesItem
      FavoritesItem favoritesItem = FavoritesItem(
        userId: widget._rememberCurrentUser.user.user_id,
        productId: widget.product.productId,
      );

      // Call the function to add to favorites
      await Mysql().addToFavorites(favoritesItem);

      print('Product added to favorites successfully!');
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print('Error adding product to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'lib/assets/images/image${widget.product.productId}.jpg',
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.productName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.product.details,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Price: \$${widget.product.price}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: addToCart,
                    child: Text('Add to Cart'),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: addToFavorites,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
