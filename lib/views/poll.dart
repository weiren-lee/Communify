import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/polls_tile.dart';
import 'package:flutter/material.dart';
import 'package:polls/polls.dart';
import 'create_poll.dart';
import 'package:intl/intl.dart';

class Poll extends StatefulWidget {
  final String houseId;

  const Poll({Key? key, required this.houseId}) : super(key: key);

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  late Stream pollStream;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  Widget pollList() {
    return StreamBuilder(
      stream: pollStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String user = authService.getUserName();

                  return PollsTile(
                    creator: snapshot.data.docs[index].data()['createdBy'],
                    usersWhoVoted:
                        snapshot.data.docs[index].data()['usersWhoVoted'],
                    pollOptions:
                        snapshot.data.docs[index].data()['pollOptions'],
                    pollName: snapshot.data.docs[index].data()['pollName'],
                    pollNoOfOptions:
                        snapshot.data.docs[index].data()['pollNoOfOptions'],
                    user: user,
                    pollOptionsValues:
                        snapshot.data.docs[index].data()['pollOptionsValues'],
                    pollId: snapshot.data.docs[index].data()['pollId'],
                    pollDetails: snapshot.data.docs[index].data()['pollDetails'],
                  );
                },
              );
      },
    );
  }

  @override
  void initState() {
    databaseService.getPollData(widget.houseId).then((val) {
      setState(() {
        pollStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              const Spacer(),
              const Icon(
                Icons.add,
                color: Colors.transparent,
              ),
              const Text('Polls',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.blueGrey)),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePoll(houseId: widget.houseId)));
                  },
                  child: Icon(
                    Icons.addchart_outlined,
                    color: Colors.grey[600],

                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(child: pollList()),
        ],
      ),
    );
  }
}
