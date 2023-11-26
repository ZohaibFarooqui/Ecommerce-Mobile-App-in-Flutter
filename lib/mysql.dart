import 'package:mysql1/mysql1.dart';
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
