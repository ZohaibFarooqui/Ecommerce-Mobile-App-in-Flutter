// admin_home_fragment_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';
import 'add_product_screen.dart';
import 'product_details_screen.dart';
import 'update_product_screen.dart'; // Import the UpdateProductScreen
import 'delete_product_screen.dart'; // Import the DeleteProductScreen
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
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(),
        child: Row(
          children: [

            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                print('press');
                // Handle menu button press
              },
            ),
            Spacer(),

            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Text(
                "Admin Home",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Spacer(),
          ],
        ),
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
              product: product,
              imagePath: 'lib/assets/images/image${product.productId}.jpg',
              onUpdate: () {
                // Navigate to UpdateProductScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProductScreen(product: product),
                  ),
                );
              },
              onDelete: () {
                // Navigate to DeleteProductScreen
                _navigateToDeleteProduct(product);
              },
            );
          }).toList(),
        ),
      );
    } else {
      return Text('No products available.');
    }
  }

  void _navigateToDeleteProduct(Product product) async {
    bool productDeleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteProductScreen(products: [product]),
      ),
    );
    if (productDeleted) {
      // Product was deleted, update the product list
      fetchProducts();
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
                "Welcome to ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text(
                  "Admin Home Screen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
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
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  ProductItem({
    required this.product,
    required this.imagePath,
    required this.onUpdate,
    required this.onDelete,
  });

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
                  image: AssetImage(imagePath),
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
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onUpdate,
                  child: Text('Update'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
