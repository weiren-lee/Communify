import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddEvent extends StatefulWidget {
  final DateTime? selectedDate;
  final String houseId;
  final event;

  const AddEvent(
      {Key? key,
      required this.selectedDate,
      required this.houseId,
      required this.event})
      : super(key: key);

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
    DateTime eventDate = DateTime.now();
    eventDetails = '';
    eventId = randomAlphaNumeric(16);

    if (widget.event != null) {
      eventId = widget.event['eventId'];
      eventDate = DateTime.parse(widget.event?['eventDatetime']);
      eventTitle = widget.event['eventTitle'];
      eventDetails = widget.event['eventDetails'];
    }

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
                  _formKey.currentState?.save();
                  // eventDatetime = ((_formKey.currentState!.value['date'] as DateTime).millisecondsSinceEpoch).toString();
                  eventDatetime =
                      (_formKey.currentState!.value['date'] as DateTime)
                          .toString()
                          .substring(0, 23);
                  Map<String, String> eventMap = {
                    "eventId": eventId,
                    "eventTitle": eventTitle,
                    "eventDetails": eventDetails,
                    "eventDatetime": eventDatetime,
                    "createdBy": authService.getUserName(),
                    "houseId": widget.houseId,
                  };
                  await databaseService.addEventData(eventMap, eventId);

                  Navigator.pop(context);
                }

              },
              child: const Text("Save Event"),
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
                  initialValue: widget.event?['eventTitle'],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'Must not be nil'),
                  ]),
                  decoration: const InputDecoration(
                    hintText: "Add Title",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (val) {
                    eventTitle = val!;
                  },
                ),
                const Divider(),
                FormBuilderTextField(
                  name: "description",
                  initialValue: widget.event?['eventDetails'],
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      hintText: "Add Details (optional)",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                  onChanged: (val) {
                    eventDetails = val!;
                  },
                ),
                const Divider(),
                FormBuilderDateTimePicker(
                  name: "date",
                  initialValue: widget.selectedDate ?? eventDate,
                  initialDate: DateTime.now(),
                  fieldHintText: "Add Date",
                  initialDatePickerMode: DatePickerMode.day,
                  inputType: InputType.both,
                  format: DateFormat('EEEE, dd MMMM, yyyy, h:mm a'),
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
