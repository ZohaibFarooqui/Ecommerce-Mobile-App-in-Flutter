import 'dart:convert';
import 'package:ecommerce/mysql.dart';
import 'package:ecommerce/users/authentication/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
import '../../api_connection/api_connection.dart';
import '../model/user.dart';
import 'login_screen.dart';
import 'package:ecommerce/mysql.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late VideoPlayerController _controller;
  bool _obscureText = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      "lib/assets/videos/file.mp4", // Replace with the actual path to your video asset
    )
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }
  void registerUser() async {
    String userName = nameController.text;
    String userEmail = emailController.text;
    String password = passwordController.text;

    try {
      if (userName.isEmpty || userEmail.isEmpty || password.isEmpty) {
        // Fluttertoast.showToast(msg: "Error! TextBoxes can't be empty.");
        return;
      }

      // Call the registerUser function from your MySQL class
      var mysql = Mysql();
      int registrationResult =
      await mysql.registerUser(userName, userEmail, password);
      var mail = await mysql.getResults('select * from ecommerce.customer;');
      for (var row in mail) {
        String Email = row.assoc()['email'] ?? '';
        if (userEmail == Email) {
          // Fluttertoast.showToast(msg: "Email is already registered.");
          return;
        }
      }

      // Registration successful, you might want to navigate to another screen
      if (registrationResult == 1) {
        print('User registered successfully');

        Flushbar(
          message: 'User registered successfully.',
          duration: Duration(seconds: 3), // Set the duration for how long the Flushbar should be visible
          backgroundColor: Colors.red, // You can customize the background color
        )..show(context);
        // Fluttertoast.showToast(msg: "User registered successfully");
        Get.off(LoginScreen());
      } else {
        // Registration failed, show an error message
        print('User registration failed');

        Flushbar(
          message: 'User registeraion failed.',
          duration: Duration(seconds: 3), // Set the duration for how long the Flushbar should be visible
          backgroundColor: Colors.red, // You can customize the background color
        )..show(context);
        // Fluttertoast.showToast(msg: "User registration failed");
        // Show an error message to the user
      }
    } catch (e) {
      print('Error during registration: $e');

      Flushbar(
        message: 'Error During Registeration.',
        duration: Duration(seconds: 3), // Set the duration for how long the Flushbar should be visible
        backgroundColor: Colors.red, // You can customize the background color
      )..show(context);
      // Fluttertoast.showToast(msg: "Error during registration. Please try again.");
    }
  }

  //registerUser(nameController, emailController, passwordController)
  //   userEmail = emailController.text;
  //   userName  = nameController.text;
  //   password = passwordController.text;
  //
  //   try {
  //     var mysql = Mysql();
  //     // Check if the email is already registered
  //     var mail = await mysql.getResults('select * from ecommerce.user;');
  //     for (var row in mail) {
  //       String Email = row.assoc()['email'] ?? '';
  //       if (userEmail == Email) {
  //         Fluttertoast.showToast(msg: "Email is already registered.");
  //         return;
  //       }
  //     }
  //
  //     // Register the user
  //     await mysql.executeQuery(
  //       'INSERT INTO ecommerce.user (user_name, email, password) VALUES (?, ?, ?)',
  //       [userName, userEmail, password],
  //     );
  //
  //     Fluttertoast.showToast(msg: "User registered successfully.");
  //   } catch (e) {
  //     print('Error during registration: $e');
  //     Fluttertoast.showToast(msg: "Error during registration. Please try again.");
  //   }
  // }


  // Future<void> validateUserEmail(String email) async {
  //   try {
  //     var res = await http.post(
  //       Uri.parse(API.validateEmail), // Replace with your API endpoint
  //       body: {
  //         'user_email': emailController.text.trim(),
  //       },
  //     );
  //     print("after response");
  //     if (res.statusCode == 200) {
  //       print("200 after response");
  //       print(res.body);
  //       var resBodyOfValidateEmail = jsonDecode(res.body);
  //
  //       if (resBodyOfValidateEmail['emailFound'] == true) {
  //         Fluttertoast.showToast(msg: "Email is already in use");
  //         setState(() {
  //           nameController.clear();
  //           emailController.clear();
  //           passwordController.clear();
  //         });
  //       } else {
  //         // Handle successful registration or other logic here
  //         registerAndSaveUserRecord();
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }


  // registerAndSaveUserRecord() async {
  //   var mysql = Mysql();
  //
  //   try {
  //     await mysql.registerUser(
  //       nameController.text.trim(),
  //       emailController.text.trim(),
  //       passwordController.text.trim(),
  //     );
  //
  //     Fluttertoast.showToast(msg: "Sign Up Successfully.");
  //   } catch (e) {
  //     // Handle any errors or show appropriate messages
  //     print('Error during registration: $e');
  //     Fluttertoast.showToast(msg: "Error Occurred, Try Again.");
  //   }
  // }






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
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      'Sign Up to the',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                      'E-COMMERCE STORE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'Username',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70, right: 50),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'john',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 130),
                    child: Text(
                      'Email',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150, right: 50),
                    child: TextField(
                      controller: emailController,
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
                        print("inside onpressed");
                        // Add your button's action here
                        if (nameController.text.isNotEmpty
                            && emailController.text.isNotEmpty
                            && passwordController.text.isNotEmpty) {
                          print("onside onpressed if");
                          registerUser();
                          // registerAndSaveUserRecord();
                          //validateUserEmail(emailController.text.trim());

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: const Size(160.0, 50.0),
                        onPrimary: Colors.white,
                        elevation: 5,
                      ),
                      child: const Stack(
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 68),
                            child: Icon(Icons.arrow_right_outlined, size: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Don't have an Account Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 340, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          "Already have an Account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const LoginScreen());
                            // Add your registration navigation here
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(110, 375, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Or",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Are you an Admin
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 385, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          "Are You an Admin?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.off(AdminScreen());
                            // Add your registration navigation here
                          },
                          child: const Text(
                            "Click Here",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
