import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mysql.dart';
import 'package:ecommerce/users/authentication/login_screen.dart';
import 'package:ecommerce/users/userPreferences/current_user.dart';
import 'package:ecommerce/users/userPreferences/user_preferences.dart';

class ProfileFragmentScreen extends StatefulWidget {
  @override
  _ProfileFragmentScreenState createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("lib/assets/images/man.png"),
            ),
            SizedBox(height: 20),
            GetBuilder<CurrentUser>(
              builder: (currentUser) => userInfoItemProfile(
                Icons.person,
                currentUser.user?.user_name ?? "",
              ),
            ),
            SizedBox(height: 20),
            GetBuilder<CurrentUser>(
              builder: (currentUser) => userInfoItemProfile(
                Icons.email,
                currentUser.user?.user_email ?? "",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signOutUser();
                // Add your logout logic here
              },
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }

  Widget userInfoItemProfile(IconData? iconData, String? userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16),
          Text(
            userData ?? '',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  signOutUser() async {
    var result = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
        ),
        content: const Text(
            "Are You Sure?\nyou want to logout from the app?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
    if (result == "loggedOut") {
      RememberUserPreferences.removeUserInfo().then((value) {
        Get.off(const LoginScreen());
      });
    }
  }
}
