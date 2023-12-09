// update_product_screen.dart

import 'package:ecommerce/users/fragments/product.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  UpdateProductScreen({required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController productNameController;
  late TextEditingController brandController;
  late TextEditingController detailsController;
  late TextEditingController sizeController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(text: widget.product.productName);
    brandController = TextEditingController(text: widget.product.brand);
    detailsController = TextEditingController(text: widget.product.details);
    sizeController = TextEditingController(text: widget.product.size);
    priceController = TextEditingController(text: widget.product.price.toString());
  }

  void _updateProduct() async {
    // Validate form fields
    if (productNameController.text.isEmpty ||
        brandController.text.isEmpty ||
        detailsController.text.isEmpty ||
        sizeController.text.isEmpty ||
        priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      print("Failed to update product");
      return;
    }

    // Update product in the database
    try {
      var mysql = Mysql();
      var result = await mysql.updateProduct(
        widget.product.productId,
        productNameController.text,
        brandController.text,
        detailsController.text,
        sizeController.text,
        int.tryParse(priceController.text) ?? 0,
      );

      if (result == 1) {
        // Product updated successfully
        // Optionally, navigate back
        Navigator.pop(context);
      } else {
        // Handle error, show an error message or log the error
      }
    } catch (e) {
      print('Error updating product: $e');
      // Show a user-friendly error message or log the error for further investigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
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
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
