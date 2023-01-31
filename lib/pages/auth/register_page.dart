import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/helper/helperFunctions.dart';
import 'package:group_chat/pages/auth/login_page.dart';
import 'package:group_chat/pages/home_page.dart';
import 'package:group_chat/service/auth_service.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final _formKeys = GlobalKey<FormState>();
    String _email = "";
    String _password = "";
    String _fullName = "";
    bool _isLoading = false;
    AuthService authService = AuthService();

    _register() async {
      if (_formKeys.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await authService
            .registerUser(_fullName, _password, _email)
            .then((value) async {
          if (value == true) {
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(_email);
            await HelperFunctions.saveUserNameSF(_fullName);
            nextScreenReplace(context, const HomePage());
          } else {
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    }

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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Form(
                      key: _formKeys,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Groupie',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Create an account to chat and explore!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Image.asset('assets/register.png'),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              // setState(() {
                              _fullName = value;
                              // });
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return 'Full name must be atleast 6 characters long!';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor),
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                            validator: (value) {
                              return RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value!)
                                  ? null
                                  : 'Please enter valid email address!';
                            },
                          ),
                          const SizedBox(
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
                              _password = val;
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
                                _register();
                              },
                              child: const Text(
                                'Register',
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
                              text: 'Already have an account?',
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Sign in here',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            nextScreen(
                                                context, const LogInPage())
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
