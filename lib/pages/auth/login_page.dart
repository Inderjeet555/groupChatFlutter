import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/pages/auth/register_page.dart';
import 'package:group_chat/service/auth_service.dart';
import 'package:group_chat/service/database_Service.dart';
import '../../helper/helperFunctions.dart';
import '../../widgets/widgets.dart';
import '../home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKeys = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  _login() async {
    if (_formKeys.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.logInUser(password, email).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreen(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: _formKeys,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        const  Text(
                            'Groupie',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                       const   SizedBox(
                            height: 10,
                          ),
                         const Text(
                            'Login now to see what they are talking!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Image.asset('assets/login.png'),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) {
                              return RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value!)
                                  ? null
                                  : 'Please enter valid email address!';
                            },
                          ),
                        const  SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                          ),
                         const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _login();
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                            ),
                          ),
                         const SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'Dont have an account?',
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Register here',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            nextScreen(
                                                context, const RegisterPage())
                                          })
                              ],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14)))
                        ],
                      )),
                ),
              ));
  }
}
