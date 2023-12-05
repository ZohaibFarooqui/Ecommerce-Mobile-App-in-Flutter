import 'package:ecommerce/mysql.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../userPreferences/current_user.dart';
final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
class CartItem {
  final int userId;
  final int productId;
  final int quantity;
  final double price;
  final String cusAddress;
  final int cusPhoneNo;

  CartItem({
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.cusAddress,
    required this.cusPhoneNo,
  });

  factory CartItem.fromMapWithProduct(Map<String, dynamic> map) {
    return CartItem(
      userId: map['user_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      price: map['price'],
      cusAddress: map['cus_address'],
      cusPhoneNo: map['cus_phone_no'],
    );
  }
}

Future<void> main() async {
  CartItem cartItem = CartItem(
    userId: _rememberCurrentUser.user.user_id, // Replace with your actual user ID
    productId: await getProductID(),
    quantity: 2, // Replace with your desired quantity
    price: 19.99,
    cusAddress: '', // Include your actual address
    cusPhoneNo: 123456789, // Replace with your actual phone number
  );

  // Make sure the addToCart method is implemented in the Mysql class
  await Mysql().addToCart(cartItem);
}

Future<int> getProductID() async {
  try {
    var mysql = Mysql();
    var query = 'SELECT * FROM ecommerce.product';
    var productsData = await mysql.getResults(query);

    return productsData.map((product) {
      return int.tryParse(product.assoc()['product_id'].toString()) ?? 0;
    }).toList().first;
  } catch (e) {
    print('Error fetching products: $e');
    return 0; // Return a default value or handle the error accordingly
  }
}
