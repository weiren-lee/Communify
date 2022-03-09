import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddEvent extends StatefulWidget {
  final DateTime? selectedDate;

  const AddEvent({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String eventId, eventTitle, eventDetails, eventDatetime, createdBy;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                _formKey.currentState?.save();
                eventDatetime = ((_formKey.currentState!.value['date'] as DateTime).millisecondsSinceEpoch).toString();
                eventId = randomAlphaNumeric(16);
                Map<String, String> eventMap = {
                  "eventId": eventId,
                  "eventTitle": eventTitle,
                  "feedImageUrl": eventDetails,
                  "eventDatetime": eventDatetime,
                  "createdBy": authService.getUserName(),
                };
                await databaseService.addEventData(eventMap, eventId);

                Navigator.pop(context);
                },
              child: const Text("Create Event"),
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
                  // initialValue: widget.event?.title,
                  decoration: const InputDecoration(
                      hintText: "Add Title",
                      border: InputBorder.none,
                      // contentPadding: EdgeInsets.only(left: 48.0),
                      prefixIcon: Icon(Icons.title),
            ),
                  onChanged: (val) {
                    eventTitle = val!;
                  },
                ),
                const Divider(),
                FormBuilderTextField(
                  name: "description",
                  // initialValue: widget.event?.description,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      hintText: "Add Details",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                  onChanged: (val) {
                    eventDetails = val!;
                  },
                ),
                const Divider(),
                FormBuilderDateTimePicker(
                  name: "date",
                  initialValue: widget.selectedDate ??
                      // widget.event?.date ??
                      DateTime.now(),
                  initialDate: DateTime.now(),
                  fieldHintText: "Add Date",
                  initialDatePickerMode: DatePickerMode.day,
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
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
