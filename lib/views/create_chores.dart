import 'package:communify/views/create_chores_two.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:communify/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateChores extends StatefulWidget {
  final dynamic houseId;

  const CreateChores({Key? key, required this.houseId}) : super(key: key);

  @override
  _CreateChoresState createState() => _CreateChoresState();
}

class _CreateChoresState extends State<CreateChores> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String choreName;
  List<String> names = [];
  List noOfOptions = [2, 3, 4];
  var randomiserNoOfOptions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateChoresTwo(
                                houseId: widget.houseId,
                                choreName: choreName,
                                randomiserNoOfOptions: randomiserNoOfOptions ?? 2,
                              )));
                }
              },
              child: const Text("Next"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          //add event form
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'Must not be nil'),
                  ]),
                  decoration: const InputDecoration(
                    hintText: "Chore Name",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (val) {
                    choreName = val!;
                  },
                ),
                const Divider(),
                FormBuilderDropdown(
                  name: 'options',
                  decoration: const InputDecoration(
                    labelText: 'No. of People to Randomise',
                  ),
                  allowClear: true,
                  initialValue: 2,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  items: noOfOptions
                      .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text('$val'),
                  ))
                      .toList(),
                  onChanged: (val) {
                    randomiserNoOfOptions = val!;
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
