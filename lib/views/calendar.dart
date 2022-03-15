import 'dart:collection';
import 'package:communify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'add_event.dart';
import 'event_details.dart';

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
  late Stream eventsStream;
  DatabaseService databaseService = DatabaseService();
  late LinkedHashMap<DateTime, List> _groupedEvents;

  @override
  void initState() {
    databaseService.getEventsData(widget.houseId).then((val) {
      setState(() {
        eventsStream = val;
      });
    });
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    for (var event in events) {
      // print(_selectedDay?.millisecondsSinceEpoch);
      // print(_groupedEvents[hashCode]);
      // print(_groupedEvents[(int.parse(event['eventDatetime']))]);
      DateTime e = DateTime.parse(event['eventDatetime']);
      DateTime date = DateTime.utc(e.year, e.month, e.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]?.add(event);

      // if (event['eventDatetime'] == _selectedDay.toString().substring(0,23)) print('hello');
      // print(DateTime.utc(int.parse(event['eventDatetime'])));

      // DateTime date = DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      // if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      // _groupedEvents[date]?.add(event);
      // print(DateTime.fromMillisecondsSinceEpoch(int.parse(event['eventDatetime'])));
    }
  }

  List<dynamic> _getEventsForDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: eventsStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // if (snapshot.hasData) {
            final events = snapshot.data.docs;
            _groupEvents(events);
            DateTime? selectedDate = _selectedDay;
            final _selectedEvents = _groupedEvents[selectedDate] ?? [];

            return Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    eventLoader: _getEventsForDay,
                    rowHeight: 48,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay =
                            focusedDay; // update `_focusedDay` here as well
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
                    weekendDays: const [DateTime.saturday, DateTime.sunday],
                    headerStyle: HeaderStyle(
                      // titleCentered: true,
                      // formatButtonVisible: false,
                      formatButtonShowsNext: false,
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      headerMargin: const EdgeInsets.only(bottom: 8.0),
                      titleTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      formatButtonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle:
                          const TextStyle(color: Colors.white),
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
                _selectedDay == null
                    ? Container()
                    : ListTile(
                        leading: const Icon(
                          Icons.add,
                          color: Colors.transparent,
                        ),
                        title: Center(
                          child: Text(
                            DateFormat('EEEE, dd MMMM, yyyy')
                                .format(_selectedDay!),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.bookmark_add_outlined),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEvent(
                                          selectedDate: _selectedDay,
                                          houseId: widget.houseId,
                                          event: null,
                                        )));
                          },
                        ),
                      ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      // var event = _selectedEvents[index];
                      return Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          border: Border.all(color: Colors.blueGrey.shade200),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          title: Text(
                              snapshot.data.docs[index].data()['eventTitle']),
                          subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy, h:mm a")
                              .format(DateTime.parse(snapshot.data.docs[index]
                                  .data()['eventDatetime']))),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventDetails(
                                          event:
                                              snapshot.data.docs[index].data(),
                                          houseId: widget.houseId,
                                        )));
                          },
                          trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddEvent(
                                                selectedDate: null,
                                                houseId: widget.houseId,
                                                event: snapshot.data.docs[index]
                                                    .data())))
                                  }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          // },
          ),
    );
  }
}
