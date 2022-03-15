import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:communify/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateChoresTwo extends StatefulWidget {
  final dynamic houseId;
  final dynamic choreName;
  final dynamic randomiserNoOfOptions;

  const CreateChoresTwo(
      {Key? key,
      required this.houseId,
      required this.choreName,
      required this.randomiserNoOfOptions})
      : super(key: key);

  @override
  _CreateChoresTwoState createState() => _CreateChoresTwoState();
}

class _CreateChoresTwoState extends State<CreateChoresTwo> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DatabaseService databaseService = DatabaseService();
  late String choreId;
  List<String> names = [];
  var randomiserNoOfOptions;

  Widget getRandomiseName(options) {
    List<Widget> list = [];
    for (var i = 0; i < options; i++) {
      list.add(
        FormBuilderTextField(
          name: "name$i",
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context,
                errorText: 'Must not be nil'),
          ]),
          decoration: const InputDecoration(
            hintText: "Assignee",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person),
          ),
        ),
      );
      list.add(
        const Divider(),
      );
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var nameOptions = [];
                  _formKey.currentState?.save();
                  choreId = randomAlphaNumeric(16);
                  for (var i = 0; i < widget.randomiserNoOfOptions; i++) {
                    nameOptions.insert(
                        i, _formKey.currentState!.value['name$i']);
                  }
                  var random = Random();
                  var assignedUser =
                      nameOptions[random.nextInt(nameOptions.length)];
                  Map<String, dynamic> choreMap = {
                    "choreId": choreId,
                    "choreName": widget.choreName,
                    "assignedUser": assignedUser,
                    "status": "incomplete",
                    "houseId": widget.houseId,
                  };
                  await databaseService.addChoresData(choreMap, choreId);
                  var count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                }
              },
              child: const Text("Create Chore"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                getRandomiseName(widget.randomiserNoOfOptions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
