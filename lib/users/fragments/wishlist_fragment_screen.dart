import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mysql.dart';
import '../userPreferences/current_user.dart';

class FavoritesFragmentScreen extends StatefulWidget {
  final int userId;

  FavoritesFragmentScreen({required this.userId});

  @override
  _FavoritesFragmentScreenState createState() => _FavoritesFragmentScreenState();
}

class _FavoritesFragmentScreenState extends State<FavoritesFragmentScreen> {
  late List<Map<String, dynamic>> favorites;

  @override
  void initState() {
    super.initState();
    fetchFavoritesData();
  }

  Future<void> fetchFavoritesData() async {
    try {
      final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
      var favoritesQuery = '''
        SELECT f.favorite_id, f.user_id, f.product_id,
               p.product_name, p.brand, p.details, p.size, p.price
        FROM ecommerce.favorites f
        JOIN ecommerce.product p ON f.product_id = p.product_id
        WHERE f.user_id = ${_rememberCurrentUser.user.user_id}
      ''';

      var favoritesResults = await Mysql().getResults(favoritesQuery);

      setState(() {
        favorites = favoritesResults.map((row) => row.assoc()).toList();
      });
    } catch (e) {
      print('Error fetching favorites data: $e');
    }
  }

  Widget buildFavorites() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (favorites.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                var favorite = favorites[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(' ${favorite['product_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Add more details as needed
                      ],
                    ),
                    leading: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/image${favorite['product_id']}.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: Text('No favorites available.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear the favorites by updating the favorites list
              setState(() {
                favorites.clear();
              });
            },
            child: Text('Empty Favorites'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Screen', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: buildFavorites(),
    );
  }
}
