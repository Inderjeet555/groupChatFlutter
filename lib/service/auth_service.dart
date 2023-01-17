import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_chat/pages/home_page.dart';
import 'package:group_chat/service/database_Service.dart';
import 'package:group_chat/widgets/widgets.dart';

import '../helper/helperFunctions.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser(String fullName, String password, String email) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      } else {}
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future logInUser(String password, String email) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      } else {}
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();
      //nextScreen(context, const HomePage());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
