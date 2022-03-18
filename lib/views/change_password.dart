import 'package:flutter/material.dart';
import 'package:communify/services/auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AuthService authService = AuthService();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  // checkPass(password) async {
  //   var correct = await authService.checkPassword(password);
  //   if (correct == true) {
  //     return true;
  //   }
  //   return false;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Change Password"),
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    await authService.updatePassword(_formKey.currentState!.value['newPassword']);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            )
          ],
    ),
      body: FormBuilder(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    // FormBuilderTextField(
                    //   name: "oldPassword",
                    //   obscureText: true,
                    //   maxLines: 1,
                    //   validator: (val){
                    //     if(checkPass(val)==true) {
                    //       return 'Wrong password';
                    //     }
                    //     return null;
                    //   },
                    //   decoration: const InputDecoration(
                    //     hintText: "Old Password",
                    //     border: InputBorder.none,
                    //     prefixIcon: Icon(Icons.lock),
                    //   ),
                    // ),
                    // const Divider(),
                    FormBuilderTextField(
                      name: "newPassword",
                      controller: _pass,
                      obscureText: _isObscure,
                      maxLines: 1,
                      validator: (val){
                        if(val!.isEmpty) {
                          return 'Must not be nil';
                        }
                        if(val.length < 6) {
                          return 'Password must be more than 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock),
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
                    ),
                    const Divider(),
                    FormBuilderTextField(
                      name: "checkPassword",
                      controller: _confirmPass,
                      obscureText: _isObscure2,
                      maxLines: 1,
                      validator: (val){
                        if(val!.isEmpty) {
                          return 'Must not be nil';
                        }
                        if(val != _pass.text) {
                          return 'Passwords do not Match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Re-enter Password",
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _isObscure2 ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                          iconSize: 20,
                        )
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
