import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mysql.dart';
import '../userPreferences/current_user.dart';

class OrderFragmentScreen extends StatefulWidget {
  final int userId;

  OrderFragmentScreen({required this.userId});

  @override
  _OrderFragmentScreenState createState() => _OrderFragmentScreenState();
}

class _OrderFragmentScreenState extends State<OrderFragmentScreen> {
  late List<Map<String, dynamic>> orders;

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
  }

  Future<void> fetchOrdersData() async {
    try {
      final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
      var ordersQuery = '''
        SELECT o.order_id, o.user_id, o.product_id, o.total_bill, o.order_date, o.order_status,
               o.cus_address, o.cus_phone_no, o.quantity,
               p.product_name, p.brand, p.details, p.size, p.price
        FROM ecommerce.orders o
        JOIN ecommerce.product p ON o.product_id = p.product_id
        WHERE o.user_id = ${_rememberCurrentUser.user.user_id}
      ''';

      var ordersResults = await Mysql().getResults(ordersQuery);

      setState(() {
        orders = ordersResults.map((row) => row.assoc()).toList();
      });
    } catch (e) {
      print('Error fetching orders data: $e');
    }
  }

  Widget buildOrders() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (orders.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(' ${order['product_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add more details as needed
                      ],
                    ),
                    leading: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/image${order['product_id']}.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: Text('No orders available.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear the cart by updating the orders list
              setState(() {
                orders.clear();
              });
            },
            child: Text('Empty Cart'),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Screen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: buildOrders(),
    );
  }
}
