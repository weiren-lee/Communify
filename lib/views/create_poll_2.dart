import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class CreatePollTwo extends StatefulWidget {
  final String houseId;
  final String pollTitle, pollDetails;
  final dynamic pollNoOfOptions;

  const CreatePollTwo(
      {Key? key,
      required this.houseId,
      required this.pollTitle,
      required this.pollDetails,
      this.pollNoOfOptions})
      : super(key: key);

  @override
  _CreatePollTwoState createState() => _CreatePollTwoState();
}

class _CreatePollTwoState extends State<CreatePollTwo> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  late String pollId;
  List pollOptions = [];
  List pollOptionsValues = [];

  Widget getDateTimeWidget(options) {
    List<Widget> list = [];
    for (var i = 0; i < options; i++) {
      list.add(
        FormBuilderDateTimePicker(
          name: "date$i",
          // initialValue: DateTime.now(),
          // initialDate: DateTime.now(),
          autovalidateMode: AutovalidateMode.always,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(context,
                errorText: 'Must not be nil'),
          ]),
          fieldHintText: "Add Date",
          initialDatePickerMode: DatePickerMode.day,
          inputType: InputType.both,
          format: DateFormat('EEEE, dd MMMM, yyyy, h:mm a'),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.calendar_today_sharp),
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
                pollOptions = [];
                pollOptionsValues = [];
                _formKey.currentState?.save();
                pollId = randomAlphaNumeric(16);
                for (var i = 0; i < widget.pollNoOfOptions; i++) {
                  pollOptions.insert(
                      i,
                      (_formKey.currentState!.value['date$i'] as DateTime)
                          .toString()
                          .substring(0, 23));
                  pollOptionsValues.insert(i, 0);
                }
                Map<String, dynamic> pollMap = {
                  "pollId": pollId,
                  "pollName": widget.pollTitle,
                  "pollDetails": widget.pollDetails,
                  "pollNoOfOptions": widget.pollNoOfOptions,
                  "pollOptions": pollOptions,
                  "createdBy": authService.getUserName(),
                  "houseId": widget.houseId,
                  "usersWhoVoted": {},
                  "pollOptionsValues": pollOptionsValues,
                };
                await databaseService.addPolData(pollMap, pollId);

                Navigator.pop(context);
              },
              child: const Text("Create Poll"),
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
                getDateTimeWidget(widget.pollNoOfOptions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
