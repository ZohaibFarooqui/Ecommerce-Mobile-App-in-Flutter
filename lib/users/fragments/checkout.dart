import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/mysql.dart';
import '../userPreferences/current_user.dart';
import 'dashboard_of_fragments.dart';
import 'package:another_flushbar/flushbar.dart';

class OrderService {
  final Mysql _mysql;

  OrderService(this._mysql);

  Future<void> saveOrderDetails(int userId, double totalBill, String paymentMethod) async {
    try {
      print('Saving order details for user $userId with total bill $totalBill and payment method $paymentMethod');
      await _mysql.savePaymentDetails(userId, totalBill, paymentMethod);
    } catch (e) {
      print('Error saving order details: $e');
      rethrow;
    }
  }

  Future<void> saveCustomerDetails(int userId, String userName, String userEmail, String userPassword, String address, String phoneNo, String gender) async {
    await _mysql.saveCustomerDetails(userId, userName, userEmail, userPassword, address, phoneNo, gender);
  }
}

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  CheckoutScreen({required this.orders});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late double totalBill;
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  String selectedPaymentMethod = '';

  late OrderService _orderService;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService(Mysql());
    calculateTotalBill();
  }

  void calculateTotalBill() {
    totalBill = widget.orders
        .map<double>((order) => double.parse(order['total_bill'].toString()))
        .reduce((value, element) => value + element);
  }

  Future<void> placeOrder() async {
    try {
      final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

      await _orderService.saveOrderDetails(
        _rememberCurrentUser.user.user_id,
        totalBill,
        selectedPaymentMethod,
      );

      Get.defaultDialog(
        title: 'Total Bill',
        content: Column(
          children: [
            Text('Your total bill is \$${totalBill.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text('Select Payment Method:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPaymentButton('Online'),
                SizedBox(width: 16),
                _buildPaymentButton('Cash on Delivery'),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error placing order: $e');
      showError('Failed to place order. Please try again.');
    }
  }

  Widget _buildPaymentButton(String method) {
    return ElevatedButton(
      onPressed: () {
        _selectPaymentMethod(method);
      },
      child: Text(method),
    );
  }

  Future<void> _selectPaymentMethod(String method) async {
    setState(() {
      selectedPaymentMethod = method;
    });
    Get.back(); // Close the dialog

    if (method == 'Online') {
      _promptPaymentDetails();
    } else {
      _promptCustomerDetails();
    }
  }



  Future<void> _promptPaymentDetails() async {
    Get.defaultDialog(
      title: 'Enter Card Details',
      content: Column(
        children: [
          TextField(
            controller: cardNumberController,
            decoration: InputDecoration(labelText: 'Card Number'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: expiryDateController,
            decoration: InputDecoration(labelText: 'Expiry Date'),
          ),
          TextField(
            controller: cvvController,
            decoration: InputDecoration(labelText: 'CVV'),
            keyboardType: TextInputType.number,
          ),

        ],

      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            _promptCustomerDetails();
          },
          child: Text('Proceed to Checkout'),
        ),
      ],
    );
  }

  Future<void> _promptCustomerDetails() async {
    Get.defaultDialog(
      title: 'Enter Customer Details',
      content: Column(
        children: [
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          TextField(
            controller: phoneNoController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: genderController,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Flushbar(
              message: 'Error adding product to cart!',
              duration: Duration(seconds: 3), // Set the duration for how long the Flushbar should be visible
              backgroundColor: Colors.red, // You can customize the background color
            )..show(context);
            await _completeOrder();
          },
          child: Text('Place Order'),
        ),
      ],
    );
  }

  Future<void> _completeOrder() async {
    try {
      final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

      if (selectedPaymentMethod == 'Online') {
        // Save order details for online payment
        await _orderService.saveOrderDetails(
          _rememberCurrentUser.user.user_id,
          totalBill,
          selectedPaymentMethod,
        );
      } else {
        // Save customer details for Cash on Delivery
        await _orderService.saveCustomerDetails(
          _rememberCurrentUser.user.user_id,
          _rememberCurrentUser.user.user_name,
          _rememberCurrentUser.user.user_email,
          _rememberCurrentUser.user.user_password,
          addressController.text,
          phoneNoController.text,
          genderController.text,

        );
      }

      widget.orders.clear();
      Get.back(); // Close payment details or customer details dialog
      Get.back(); // Close total bill dialog
      Get.offAll(() => DashboardOfFragments());
    } catch (e) {
      print('Error completing order: $e');

      showError('Failed to complete order. Please try again.');
    }
  }

  void showError(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Bill: \$${totalBill.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => placeOrder(),
              child: Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

