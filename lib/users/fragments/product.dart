import 'dart:typed_data';

class Product {
  final int productId;
  final String productName;
  final String brand;
  final String details;
  final String size;
  final int price;
  final Uint8List productImage;

  Product({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.details,
    required this.size,
    required this.price,
    required this.productImage,
  });

  factory Product.empty() {
    return Product(
      productId: 0,
      productName: '',
      brand: '',
      details: '',
      size: '',
      price: 0,
      productImage: Uint8List(0),
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
      productImage: Uint8List(0), // You may adjust this based on your default image
    );
  }
}
