import 'dart:convert';
import 'package:ecommerce/mysql.dart';
import 'package:ecommerce/users/authentication/signup_screen.dart';
import 'package:ecommerce/users/fragments/admin_dashboard_of_fragments.dart';
import 'package:ecommerce/users/fragments/admin_home_fragment_screen.dart';
import 'package:ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:ecommerce/users/fragments/home_fragment_screen.dart';
import 'package:ecommerce/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
 // import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce/users/fragments/dashboard_of_fragments.dart';
import '../../api_connection/api_connection.dart';
import '../model/user.dart';
import 'package:mysql_client/mysql_client.dart';
import 'login_screen.dart';
class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late VideoPlayerController _controller;
  bool _obscureText = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  loginAdminNow() async {
    var mysql = Mysql();
    try {
      var mail = await mysql.getResults('select * from ecommerce.admin;');
      print("HELLO");
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        for (var row in mail) {
          // Process the rows here
          String userEmail = row.assoc()['admin_email'] ?? '';
          print(userEmail);
          print(row.assoc()['admin_email']);
          print(emailController.text);
          if (userEmail == emailController.text) {
            print("hey");
            // Fluttertoast.showToast(msg: "Login Successfully.");
            // Add logic for successful login
            //break; // Exit the loop since we found a matching email
            //print(row.assoc()['user_name']);
          }
          else{
            // Fluttertoast.showToast(msg: "Incorrect Email");
          }
          String pass = row.assoc()['admin_password'] ?? '';
          print(pass);
          if (pass == passwordController.text) {
            print("hey");
            // Fluttertoast.showToast(msg: "Admin Logged In Successfully.");
            Get.off(AdminDashboardOfFragments());
            // Add logic for successful login
            break; // Exit the loop since we found a matching email
            //print(row.assoc()['user_name']);
          }
          else{
            // Fluttertoast.showToast(msg: "Incorrect Password");
          }
        }
      } else {
        // Handle the case where emailController is empty
        // Fluttertoast.showToast(msg: "Email or password cannot be empty.");
      }
    }



    catch (e) {
      print('Error: $e');
    }

  }



  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      "lib/assets/videos/file.mp4", // Replace with the actual path to your video asset
    )..initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video background
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 670, left: 60, right: 50),
            child: const Text(
              'All Rights Reserved. Store Inc. (2023)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Form
          Center(
            child: Container(
              height: 460,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.only(top: 40, left: 40),
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Admin Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'E-COMMERCE STORE',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),  // Add some spacing
                          child: TextFormField(
                            controller: emailController,  // Use the correct controller here
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'xyz@domain.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 210),
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 230, right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_obscureText)
                          const Text(
                            'Password: YourPasswordHere',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        TextFormField(
                          obscureText: _obscureText,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 300, left: 55),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button's action here
                        loginAdminNow();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: Size(160.0, 50.0),
                        onPrimary: Colors.white,
                        elevation: 5,
                      ),
                      child: const Stack(
                        children: [
                          Text(
                            'Log in ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(Icons.arrow_right_outlined, size: 25),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Don't have an Account Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30,340,0,0),
                    child: Row(

                      children: [
                        // const Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,330,0,0),

                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,330,0,0),
                        TextButton(
                          onPressed: () {
                            Get.to(SignupScreen());
                            // Add your registration navigation here
                          },
                          //  style: TextButton.styleFrom(
                          //    backgroundColor: Colors.blueAccent,
                          // ),// Add a background color
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blueAccent, // Set the text color to blue
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(110,375,0,0),
                    child: Row(

                      children: [
                        // const Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,330,0,0),

                        Text(
                          "Or",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        // Padding(


                      ],
                    ),
                  ),
                  // Are you an Admin
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30,385,0,0),
                    child: Row(

                      children: [
                        // const Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,330,0,0),

                        Text(
                          "Are You a User?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0,330,0,0),
                        TextButton(
                          onPressed: () {
                            Get.off(LoginScreen());
                          },
                          //  style: TextButton.styleFrom(
                          //    backgroundColor: Colors.blueAccent,
                          // ),// Add a background color
                          child: const Text(
                            "Click Here",
                            style: TextStyle(
                              color: Colors.blueAccent, // Set the text color to blue
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
