// admin_home_fragment_screen.dart

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';
import 'add_product_screen.dart';
import 'home_fragment_screen.dart';
import 'product_details_screen.dart';
import 'product.dart';

class AdminHomeFragmentScreen extends StatefulWidget {
  @override
  _AdminHomeFragmentScreenState createState() =>
      _AdminHomeFragmentScreenState();
}

class _AdminHomeFragmentScreenState extends State<AdminHomeFragmentScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    fetchProducts();

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void fetchProducts() async {
    try {
      var mysql = Mysql();
      var query = 'SELECT * FROM ecommerce.product';
      var productsData = await mysql.getResults(query);

      setState(() {
        products = productsData.map((product) {
          dynamic imageBytes = product.assoc()['product_image'];
          List<int> imageUint8List =
          (imageBytes is List<int>) ? imageBytes : [];

          return Product(
            productId:
            int.tryParse(product.assoc()['product_id'].toString()) ?? 0,
            productName: product.assoc()['product_name']?.toString() ?? '',
            brand: product.assoc()['brand']?.toString() ?? '',
            details: product.assoc()['details']?.toString() ?? '',
            size: product.assoc()['size']?.toString() ?? '',
            price: int.tryParse(product.assoc()['price'].toString()) ?? 0,
            // productImagePath:
            // product.assoc()['product_image_path']?.toString() ?? '',
          );
        }).toList();

      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget bannerContainer({required String imagePath}) {
    return Container(
      width: 325,
      height: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget banner() {
    return Column(
      children: [
        Container(
          width: 325,
          height: 160,
          child: PageView(
            controller: _pageController,
            children: [
              bannerContainer(imagePath: 'lib/assets/images/3.jpg'),
              bannerContainer(imagePath: 'lib/assets/images/4.png'),
              bannerContainer(imagePath: 'lib/assets/images/1.jpg'),
              bannerContainer(imagePath: 'lib/assets/images/5092428.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        children: [
          Text(
            "Admin Home",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildProducts() {
    if (products.isNotEmpty) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: products.map((product) {
            return ProductItem(
              imagePath: 'lib/assets/images/woman.png',
              // image: FileImage(File(product.productImagePath)),
              product: product,
            );
          }).toList(),
        ),
      );
    } else {
      return Text('No products available.');
    }
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Admin Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              banner(),
              SizedBox(height: 20),
              buildProducts(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final String imagePath;

  ProductItem({required this.product, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath), // Use the provided imagePath here
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 8),
            Text(
              product.productName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}



