import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';
import 'product.dart'; // Import your product model

class DeleteProductScreen extends StatefulWidget {
  final List<Product> products; // Assuming you have a list of products

  DeleteProductScreen({required this.products});

  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  Product? selectedProduct; // Variable to store the selected product

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<Product>(
              value: selectedProduct,
              onChanged: (Product? newValue) {
                setState(() {
                  selectedProduct = newValue;
                });
              },
              items: widget.products.map((Product product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.productName),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (selectedProduct != null) {
                  try {
                    var mysql = Mysql();
                    var result = await mysql.deleteProduct(selectedProduct!.productId);

                    if (result == 1) {
                      // Product deleted successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product deleted successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Optionally, navigate back or perform other actions
                      Navigator.pop(context);
                    } else {
                      // Handle error, show an error message or log the error
                    }
                  } catch (e) {
                    print('Error deleting product: $e');
                    // Show a user-friendly error message or log the error for further investigation
                  }
                }
              },

              child: Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }
}
