import 'package:communify/views/choose_house.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/helper/functions.dart';
import 'package:communify/services/auth.dart';
import 'package:communify/views/signup.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String email, password;
  AuthService authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

  Future<Future> showAlertDialog({
    required BuildContext context,
    required String titleText,
    required String messageText,
  }) async {
    final Widget okButton = ElevatedButton(
      onPressed: () => Navigator.pop(context, 'Ok'),
      child: const Text('Ok'),
    );
    final alert = AlertDialog(
      title: Text(titleText),
      content: Text(messageText),
      actions: [
        okButton,
      ],
    );

    return showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.signInEmailAndPass(email, password).then((val) async {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChooseHouse()));
        } else {
          setState(() {
            _isLoading = false;
          });
          await showAlertDialog(
            context: context,
            titleText: 'Please Try Again',
            messageText:
            'Username or Password is incorrect!',
          );
        }
      }
      );
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
                      const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [
                    const Spacer(),
                    const Spacer(),
                    Text(
                      '"Unifying Communities with Communication"',
                      style: TextStyle(
                          fontSize: 35,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                        child: Text('--- CommUnify', style: TextStyle(fontSize: 14),)
                    ),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
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
                        obscureText: _isObscure,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: InputDecoration(
                            labelText: "Password",
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock_open_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              iconSize: 20,
                            )),
                        onChanged: (val) {
                          password = val!;
                        }),
                    // const Divider(),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: blueButton(context, "Sign In")),
                    const Spacer(),
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
                    const Spacer(),

                  ]),
                ),
              ),
      ),
    );
  }
}
