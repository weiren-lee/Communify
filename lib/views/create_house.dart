import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class createHouse extends StatefulWidget {
  const createHouse({Key? key}) : super(key: key);

  @override
  _createHouseState createState() => _createHouseState();
}

class _createHouseState extends State<createHouse> {
  final _formKey = GlobalKey<FormState>();
  late String houseId, houseName, housePassword;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  bool _isLoading = false;

  createHouseOnline() async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('house').get();
    final int houseCount = qSnap.docs.length;
    var houseIdInt = houseCount + 1;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> houseMap = {
        "houseId": houseIdInt.toString(),
        "houseName": houseName,
        "housePassword": housePassword,
      };

      await databaseService.addHouseData(houseMap, houseIdInt.toString()).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black87),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: _isLoading
            ? const Center(
              child: CircularProgressIndicator(),
            )
            : Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Text('Create your house now!', style: TextStyle(fontSize: 20),),
                const SizedBox(height: 15,),
                TextFormField(
                  validator: (val) =>
                  val!.isEmpty ? "Enter a valid House Name!" : null,
                  decoration: const InputDecoration(
                    hintText: "House Name",
                  ),
                  onChanged: (val) {
                    houseName = val;
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  validator: (val) =>
                  val!.isEmpty ? "Enter a valid password!" : null,
                  decoration: const InputDecoration(
                    hintText: "House Password",
                  ),
                  onChanged: (val) {
                    housePassword = val;
                  },
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      createHouseOnline();
                    },
                    child: blueButton(context, "Create your House")),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        )
    );
  }
}
