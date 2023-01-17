import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "USER_KEY";
  static String userNameKey = "";
  static String userEmailKey = "";

  static Future<bool?> isUserLoggedIn() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    var key = sf.getBool(userLoggedInKey); //print(userLoggedInKey);
    print(key);
    return key;
  }

   static Future<String?> getUsername() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    var key = sf.getString(userNameKey); //print(userLoggedInKey);    
    return key;
  }

   static Future<String?> getuserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    var key = sf.getString(userEmailKey); //print(userLoggedInKey);    
    return key;
  }

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, userEmail);
  }
}
