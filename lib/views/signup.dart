import 'package:communify/services/database.dart';
import 'package:communify/views/choose_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/helper/functions.dart';
import 'package:communify/services/auth.dart';
import 'package:communify/views/signin.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, password, uid;
  AuthService authService = AuthService();
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();

  signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService
          .signUpWithEmailAndPassword(email, password, name)
          .then((value) {
        if (value != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChooseHouse()));
        }
      });
      uid = randomAlphaNumeric(16);
      final QuerySnapshot qSnap =
          await FirebaseFirestore.instance.collection('user').get();
      final int userCount = qSnap.docs.length;
      var userIdInt = userCount + 1;

      Map<String, String> userMap = {
        "name": name,
        "email": email,
        "userId": userIdInt.toString(),
      };

      await databaseService
          .addUserData(userMap, userIdInt.toString())
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: loginAppBar(context),
          backgroundColor: const Color(0xAA3385c6),
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? Container(
                child: const Center(
                child: CircularProgressIndicator(),
              ))
            : Form(
                key: _formKey,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(children: [
                    const Spacer(),
                    TextFormField(
                        validator: (val) {
                          return val!.isEmpty ? "Enter Name" : null;
                        },
                        decoration: const InputDecoration(hintText: "Name"),
                        onChanged: (val) {
                          name = val;
                        }),
                    TextFormField(
                        validator: (val) {
                          return val!.isEmpty ? "Enter Email ID" : null;
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        }),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val!.isEmpty ? "Enter Password" : null;
                        },
                        decoration: const InputDecoration(hintText: "Password"),
                        onChanged: (val) {
                          password = val;
                        }),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: blueButton((context), "Sign Up"),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(fontSize: 15.5)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()));
                            },
                            child: const Text("Sign In",
                                style: TextStyle(
                                    fontSize: 15.5,
                                    decoration: TextDecoration.underline))),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
