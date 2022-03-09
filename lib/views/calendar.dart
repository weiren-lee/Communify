import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'add_event.dart';

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year - 1, kNow.month - 1, kNow.day);
final kLastDay = DateTime(kNow.year + 1, kNow.month + 1, kNow.day);

class Calendar extends StatefulWidget {
  final String houseId;

  const Calendar({Key? key, required this.houseId}) : super(key: key);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },

                weekendDays: const [6],
                headerStyle: HeaderStyle(
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  headerMargin: const EdgeInsets.only(bottom: 8.0),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius:
                    BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: const TextStyle(color: Colors.white),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
                calendarStyle: const CalendarStyle(),
                calendarBuilders: const CalendarBuilders(),
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8.0),
            child:
            _selectedDay == null ? Container() :
            Text(
              DateFormat('EEEE, dd MMMM, yyyy').format(_selectedDay!),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigator.pushNamed(context, AppRoutes.addEvent, arguments: _selectedDay);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEvent(selectedDate: _selectedDay,))
          );
          },
      ),
    );
  }
}

// class AppRoutes {
//   static const String addEvent = "add_event";
//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     return MaterialPageRoute(
//         settings: settings,
//         builder: (_) {
//           switch (settings.name) {
//
//             case addEvent:
//               return AddEvent(
//                 selectedDate: settings.arguments,
//               );
//
//             default:
//               return SignIn();
//           }
//         });
//   }
// }