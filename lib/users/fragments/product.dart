// product.dart

import 'dart:typed_data';

class Product {
  final int productId;
  final String productName;
  final String brand;
  final String details;
  final String size;
  final int price;

  Product({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.details,
    required this.size,
    required this.price,
  });

  factory Product.empty() {
    return Product(
      productId: 0,
      productName: '',
      brand: '',
      details: '',
      size: '',
      price: 0,
    );
  }

  factory Product.defaultProduct() {
    return Product(
      productId: 0,
      productName: 'Default Product',
      brand: 'Default Brand',
      details: 'Default Details',
      size: 'Default Size',
      price: 0,
    );
  }
}
