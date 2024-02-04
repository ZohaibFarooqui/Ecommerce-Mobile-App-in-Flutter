import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce/mysql.dart';
import 'product_details_screen.dart';
import 'product.dart';
import 'dart:io';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

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
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/image${product.productId}.jpg'),
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

class HomeFragmentScreen extends StatefulWidget {
  @override
  _HomeFragmentScreenState createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  List<Product> products = [];
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];

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

    searchController.addListener(() {
      filterProducts();
    });
  }

  void fetchProducts() async {
    try {
      var mysql = Mysql();
      var query = 'SELECT * FROM ecommerce.product';
      var productsData = await mysql.getResults(query);

      setState(() {
        products = productsData.map((product) {
          return Product(
            productId: int.tryParse(product.assoc()['product_id'].toString()) ?? 0,
            productName: product.assoc()['product_name']?.toString() ?? '',
            brand: product.assoc()['brand']?.toString() ?? '',
            details: product.assoc()['details']?.toString() ?? '',
            size: product.assoc()['size']?.toString() ?? '',
            price: int.tryParse(product.assoc()['price'].toString()) ?? 0,
          );
        }).toList();
        print('Products fetched successfully: $products');
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    print('Filtering products with query: $query');

    setState(() {
      filteredProducts = products.where((product) {
        return product.productName.toLowerCase().contains(query);
      }).toList();
    });
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
          width: 350,
          height: 160,
          child: PageView(
            controller: _pageController,
            children: [
              bannerContainer(imagePath: 'lib/assets/images/3.jpg'),
              bannerContainer(imagePath: 'lib/assets/images/4.png'),
              bannerContainer(imagePath: 'lib/assets/images/5092428.jpg'),
              // bannerContainer(imagePath: 'assets/image5.png'),
            ],
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      // title: const Center(
      //   child:Padding(
      //     padding: EdgeInsets.only(right: 250),
      //     child: Text(
      //       "Home",
      //       style: TextStyle(
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // ),

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
                padding: const EdgeInsets.only(right: 135),
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.black,
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
    List<Product> displayProducts = filteredProducts.isNotEmpty ? filteredProducts : products;

    if (displayProducts.isNotEmpty) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: displayProducts.map((product) {
            return ProductItem(
              product: product,
            );
          }).toList(),
        ),
      );
    } else {
      return Text('No products available.');
    }
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
                  "E Commerce Store",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 50),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,

                    filled: true,
                    hintText: 'Search Your Item',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
    );
  }
}
