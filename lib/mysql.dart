
import 'dart:typed_data';

import 'package:ecommerce/users/fragments/favorites.dart';
import 'package:mysql1/mysql1.dart';
import 'package:ecommerce/users/fragments/Cart.dart'; // Import your Cart model
import 'package:ecommerce/users/fragments/order_fragment_screen.dart';
import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = '10.0.2.2';//for emulator
  static String user = 'root';
  static String password = 'zohaib';
  static String db = 'ecommerce';

  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    return await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
  }

  Future<Iterable<ResultSetRow>> getResults(String query) async {
    var conn = await getConnection();
    await conn.connect();
    var results = await conn.execute(query);
    conn.close();
    return results.rows;
  }

  Future<int> registerUser(String userName, String userEmail, String password) async {
    var conn = await getConnection();
    try {
      await conn.connect();

      var stmt = await conn.prepare(
        'INSERT INTO ecommerce.customer (user_name, email, password) VALUES (?, ?, ?)',
      );

      var result = await stmt.execute([userName, userEmail, password]);

      await stmt.deallocate();
      await conn.close();

      // Check if the insertion was successful
      var affectedRowsBigInt = result.affectedRows;
      if (affectedRowsBigInt != null && affectedRowsBigInt > BigInt.zero) {
        // Registration successful
        return 1;
      } else {
        // Registration failed
        return 0;
      }
    } catch (e) {
      print('Error during registration: $e');
      return 0; // Return 0 to indicate failure
    }
  }
  Future<int> addProduct(String productName, String brand, String details, String size, int price, Uint8List productImage) async {
    var conn = await getConnection();
    try {
      await conn.connect();

      var stmt = await conn.prepare(
        'INSERT INTO ecommerce.product (product_name, brand, details, Size, price, product_image) VALUES (?, ?, ?, ?, ?, ?)',
      );

      var result = await stmt.execute([productName, brand, details, size, price, productImage]);

      await stmt.deallocate();
      await conn.close();

      // Check if the insertion was successful
      var affectedRowsBigInt = result.affectedRows;
      if (affectedRowsBigInt != null && affectedRowsBigInt > BigInt.zero) {
        // Product added successfully
        return 1;
      } else {
        // Product addition failed
        return 0;
      }
    } catch (e) {
      print('Error adding product: $e');
      return 0; // Return 0 to indicate failure
    }
  }
// Ensure to import the async library

  Future<int> addToCart(CartItem cart) async {
    var conn = await getConnection();
    try {
      await conn.connect(); // Connect if not already connected

      var stmt = await conn.prepare(
        'INSERT INTO ecommerce.orders (user_id, product_id, total_bill, order_status, cus_address, cus_phone_no, quantity) VALUES (?, ?, ?, ?, ?, ?, ?)',
      );

      var result = await stmt.execute([
        cart.userId,
        cart.productId,
        cart.price * cart.quantity, // Assuming total_bill is calculated as price * quantity
        'Pending', // Order status can be set as 'Pending' by default
        cart.cusAddress,
        cart.cusPhoneNo,
        cart.quantity,
      ]);

      await stmt.deallocate();

      // Check if the insertion was successful
      var affectedRowsBigInt = result.affectedRows;
      if (affectedRowsBigInt != null && affectedRowsBigInt > BigInt.zero) {
        // Item added to the cart successfully
        return 1;
      } else {
        // Item addition to the cart failed
        return 0;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return 0; // Return 0 to indicate failure
    } finally {
      await conn?.close(); // Close the connection if not null
    }
  }

  Future<int> addToFavorites(FavoritesItem favoritesItem) async {
    var conn = await getConnection();
    try {
      await conn.connect(); // Connect if not already connected

      var stmt = await conn.prepare(
        'INSERT INTO ecommerce.favorites (user_id, product_id) VALUES (?, ?)',
      );

      var result = await stmt.execute([
        favoritesItem.userId,
        favoritesItem.productId,
      ]);

      await stmt.deallocate();

      // Check if the insertion was successful
      var affectedRowsBigInt = result.affectedRows;
      if (affectedRowsBigInt != null && affectedRowsBigInt > BigInt.zero) {
        // Item added to favorites successfully
        return 1;
      } else {
        // Item addition to favorites failed
        return 0;
      }
    } catch (e) {
      print('Error adding to Favorites: $e');
      return 0; // Return 0 to indicate failure
    } finally {
      await conn?.close(); // Close the connection if not null
    }
  }


  Future<List<CartItem>> getCartItems(int userId) async {
    var conn = await getConnection();
    try {
      var stmt = await conn.prepare(
        '''
      SELECT o.order_id, o.user_id, o.product_id, o.total_bill, o.order_date, o.order_status,
             o.cus_address, o.cus_phone_no, o.quantity,
             p.product_name, p.brand, p.details, p.size, p.price
      FROM ecommerce.orders o
      JOIN ecommerce.product p ON o.product_id = p.product_id
      WHERE o.user_id = ? AND p.product_id IS NOT NULL
      ''',
      );

      var results = await stmt.execute([userId]);

      var cartItems = results.map((row) => CartItem.fromMapWithProduct(row as Map<String, dynamic>)).toList();

      await stmt.deallocate();
      return cartItems;
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    } finally {
      await conn.close();
    }
  }





  // Future<List<Map<String, dynamic>>> getProducts() async {
  //   var conn = await getConnection();
  //
  //   await conn.connect();
  //   var stmt = await conn.prepare(
  //     'SELECT product_id, product_name, brand, details, Size, price FROM product;',
  //   );
  //   await conn.query('USE ecommerce'); // Change to your database name
  //   var results = await conn.query('SELECT product_id, product_name, brand, details, Size, price FROM product;');
  //   await conn.close();
  //
  //   return results.map((row) {
  //     return {
  //       'productId': row['product_id'],
  //       'productName': row['product_name'],
  //       'brand': row['brand'],
  //       'details': row['details'],
  //       'size': row['Size'],
  //       'price': row['price'],
  //     };
  //   }).toList();
  // }

  Future<int> placeOrder(int customerID, int restaurantID, int price) async {
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn.prepare(
        'INSERT INTO Orders (customer_id, restaurant_id, price) VALUES (?, ?, ?)');
    await stmt.execute([customerID, restaurantID, price]);
    await stmt.deallocate();
    conn.close();
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT order_id, name, status, price FROM Orders INNER JOIN Restaurant ON Orders.restaurant_id=Restaurant.restaurant_id WHERE customer_id=$customerID ORDER BY placed_at DESC LIMIT 1;');
    int orderID = 0;
    if (rows.length == 1) {
      for (var row in rows) {
        orderID = int.parse(row.assoc()['order_id']!);
      }
    }
    return orderID;
  }


}

// }
