import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/create_poll_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreatePoll extends StatefulWidget {
  final String houseId;

  const CreatePoll({Key? key, required this.houseId}) : super(key: key);

  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  late String pollTitle, pollId, pollDetails;
  var pollNoOfOptions;
  var pollOptions = [];
  var counter = 0;
  List noOfOptions = [2, 3, 4];

  @override
  Widget build(BuildContext context) {
    pollDetails = '';
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
                        builder: (context) => CreatePollTwo(
                            houseId: widget.houseId,
                            pollTitle: pollTitle,
                            pollDetails: pollDetails,
                            pollNoOfOptions: pollNoOfOptions ?? 2)),
                  );
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
                    hintText: "Poll Name",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (val) {
                    pollTitle = val!;
                  },
                ),
                const Divider(),
                FormBuilderTextField(
                  name: "details",
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      hintText: "Add Details (optional)",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                  onChanged: (val) {
                    pollDetails = val!;
                  },
                ),
                const Divider(),
                FormBuilderDropdown(
                  name: 'options',
                  decoration: const InputDecoration(
                    labelText: 'No. of Options',
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
                    pollNoOfOptions = val!;
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
