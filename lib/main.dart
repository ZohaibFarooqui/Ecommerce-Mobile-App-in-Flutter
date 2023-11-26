import 'package:ecommerce/users/authentication/login_screen.dart';
import 'package:ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:ecommerce/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();//to avoid empty white scree
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Commerce Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder (
          future: RememberUserPreferences.readUserInfo(),
          builder:(context, dataSnapShot)
        {
          if(dataSnapShot.data == null)
            {
              return const LoginScreen();
             //return DashboardOfFragments();
            }
          else
            {
              return DashboardOfFragments();
            }

        },
      ),
    );
  }
}

