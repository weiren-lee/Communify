import 'package:communify/views/choose_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/helper/functions.dart';
import 'package:communify/services/auth.dart';
import 'package:communify/views/signup.dart';
import 'package:communify/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  AuthService authService = AuthService();

  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChooseHouse()));
        }
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
          centerTitle: true,
          title: loginAppBar(context),
          backgroundColor: const Color(0xAA3385c6),
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(children: [
                    const Spacer(),
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
                          signIn();
                        },
                        child: blueButton(context, "Sign In")),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style: TextStyle(fontSize: 15.5)),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()));
                            },
                            child: const Text("Sign Up",
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
