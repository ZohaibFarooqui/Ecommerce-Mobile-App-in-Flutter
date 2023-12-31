import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late TextEditingController productNameController;
  late TextEditingController brandController;
  late TextEditingController detailsController;
  late TextEditingController sizeController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    brandController = TextEditingController();
    detailsController = TextEditingController();
    sizeController = TextEditingController();
    priceController = TextEditingController();
  }

  void _saveProduct() async {
    // Validate form fields
    if (productNameController.text.isEmpty ||
        brandController.text.isEmpty ||
        detailsController.text.isEmpty ||
        sizeController.text.isEmpty ||
        priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      print("Failed to enter products");
      return;
    }

    // Save product to database
    try {
      var mysql = Mysql();
      var result = await mysql.addProduct(
        productNameController.text,
        brandController.text,
        detailsController.text,
        sizeController.text,
        int.tryParse(priceController.text) ?? 0,
      );

      if (result == 1) {
        // Product saved successfully
        // Clear form fields
        setState(() {
          productNameController.clear();
          brandController.clear();
          detailsController.clear();
          sizeController.clear();
          priceController.clear();
        });

        // You can also show a success message if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Optionally, navigate back
        Navigator.pop(context);
      } else {
        // Handle error, show an error message or log the error
      }
    } catch (e) {
      print('Error saving product: $e');
      // Show a user-friendly error message or log the error for further investigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextFormField(
                controller: brandController,
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              TextFormField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Details'),
              ),
              TextFormField(
                controller: sizeController,
                decoration: InputDecoration(labelText: 'Size'),
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
