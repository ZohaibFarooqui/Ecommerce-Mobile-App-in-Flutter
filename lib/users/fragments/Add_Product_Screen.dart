import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    brandController = TextEditingController();
    detailsController = TextEditingController();
    sizeController = TextEditingController();
    priceController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _saveProduct() async {
    // Validate form fields
    if (_selectedImage == null || productNameController.text.isEmpty || brandController.text.isEmpty ||
        detailsController.text.isEmpty || sizeController.text.isEmpty || priceController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Convert image to bytes
    List<int> imageBytes = await _selectedImage!.readAsBytes();

    // Save product to database
    try {
      var mysql = Mysql();
      var result = await mysql.addProduct(
        productNameController.text,
        brandController.text,
        detailsController.text,
        sizeController.text,
        int.tryParse(priceController.text) ?? 0,
        Uint8List.fromList(imageBytes),
      );

      if (result == 1) {
        // Product saved successfully, you can navigate back or show a success message
        Navigator.pop(context);
      } else {
        // Handle error, show an error message or log the error
      }
    } catch (e) {
      print('Error saving product: $e');
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(height: 16),
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
