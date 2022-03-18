import 'package:communify/services/database.dart';
import 'package:communify/views/choose_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/helper/functions.dart';
import 'package:communify/services/auth.dart';
import 'package:communify/views/signin.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  late String name, email, password, uid;
  AuthService authService = AuthService();
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();
  bool _isObscure = true;

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
      HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ChooseHouse()));
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
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        // resizeToAvoidBottomInset: false,
        body: _isLoading
            ? const Center(
            child: CircularProgressIndicator(),
              )
            : FormBuilder(
                key: _formKey,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: ListView(children: [
                    const Spacer(),
                    FormBuilderTextField(
                      name: 'name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: "Display Name",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.account_box_outlined),
                        ),
                        onChanged: (val) {
                          name = val!;
                        }),
                    const Divider(),
                    FormBuilderTextField(
                      name: 'email',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        onChanged: (val) {
                          email = val!;
                        }),
                    const Divider(),
                    FormBuilderTextField(
                      name: 'password',
                        controller: _pass,
                        obscureText: _isObscure,
                        validator: (val){
                          if(val!.isEmpty) {
                            return 'Must not be nil';
                          }
                          if(val.length < 6) {
                            return 'Password must be more than 6 characters';
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                          labelText: "Password",
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.lock_open_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            iconSize: 20,
                          )
                        ),
                        onChanged: (val) {
                          password = val!;
                        }),
                    const Divider(),
                    FormBuilderTextField(
                        name: 'password2',
                        obscureText: _isObscure,
                        controller: _confirmPass,
                        validator: (val){
                          if(val!.isEmpty) {
                            return 'Must not be nil';
                          }
                          if(val != _pass.text) {
                            return 'Passwords do not Match';
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
                            labelText: "Re-enter Password",
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock_open_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              iconSize: 20,
                            )
                        ),
                        onChanged: (val) {
                          password = val!;
                        }),
                    const Divider(),
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
                      height: 20,
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
