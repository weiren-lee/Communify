import 'package:communify/views/add_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:communify/services/database.dart';

class EventDetails extends StatelessWidget {
  final event;
  final String houseId;

  const EventDetails({Key? key, required this.houseId, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvent(
                          selectedDate: null, houseId: houseId, event: event)));
              // Navigator.pushReplacementNamed(
              //   context,
              //   AppRoutes.editEvent,
              //   arguments: event,
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Warning!"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete")),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (confirm) {
                await databaseService.deleteEvent(event['eventId']);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(
              event['eventTitle'],
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                .format(DateTime.parse(event['eventDatetime']))),
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: const Icon(Icons.short_text),
            title: Text(event['eventDetails']),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            leading: const Icon(Icons.person_sharp),
            title: Text(event['createdBy']),
          ),
        ],
      ),
    );
  }
}
