import 'package:ecommerce/users/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

import '../model/user.dart';

class CurrentUser extends GetxController {
  Rx<User> _currentUser = User(0, '', '', '').obs;
  User get user => _currentUser.value;

  void setUser(User newUser) {
    _currentUser.value = newUser;
  }

  Future<void> getUserInfo() async {
    User? getUserInfoFromLocalStorage = (await RememberUserPreferences.readUserInfo()) as User?;
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
// class CurrentUser extends GetxController
// {
//   Rx<User> _currentuser = User(0,'','','').obs;
//   User get user => _currentuser.value;
//
//   getUserInfo() async
//   {
//     User? getUserInfoFromLocalStorage = await RememberUserPreferences.readUserInfo();
//     _currentuser.value = getUserInfoFromLocalStorage!;
//   }
