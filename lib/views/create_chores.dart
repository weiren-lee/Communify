import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:communify/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class createChores extends StatefulWidget {
  final houseId;


  const createChores({Key? key, required this.houseId}) : super(key: key);

  @override
  _createChoresState createState() => _createChoresState();
}

class _createChoresState extends State<createChores> {
  DatabaseService databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String choreId, choreName, assignedUser;
  List<String> names = [];

  createChoreOnline() async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('chores').get();
    final int choresCount = qSnap.docs.length;
    var choreIdInt = choresCount + 1;

    var random = Random();
    var assignedUser = names[random.nextInt(names.length)];

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> choreMap = {
        "choreId": choreIdInt.toString(),
        "choreName": choreName,
        "assignedUser": assignedUser,
        "status": "incomplete",
      };

      await databaseService.addChoresData(choreMap, choreIdInt.toString()).then((value) {
        setState(() {
          _isLoading = false;

        });
      });
    }
  }

  TextEditingController nameController = TextEditingController();

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
          ? Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Create a chore!"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (val) =>
              val!.isEmpty ? "Enter your thoughts here" : null,
              decoration: const InputDecoration(
                hintText: "Create a chore...",
              ),
              onChanged: (val) {
                choreName = val;
              },
            ),
          ),
          const Text("Randomly assigning to..."),
          Expanded(
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    names.removeAt(index);
                  });},
                child: ListTile(
                  title: Text(names[index]),
                ),
              );
            },
          )),
          Expanded(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Add new name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top:10, bottom:10),
                          isDense: true,
                      ),
                    ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          addToList();
                        },
                        child: const Text("Add"))
                  ],
                ),
                Builder(builder: (context) => ElevatedButton(
                  child: Text("Create Chore"),
                  onPressed: (){
                    createChoreOnline();
                  },
                )
                )
              ],
            ),
          )),
        ]
      ),
    )
    );
  }

  void addToList() {
    if (nameController.text.isNotEmpty) {
      setState(() {
        names.add(nameController.text);
      });
    }
  }
}


