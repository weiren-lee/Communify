import 'package:communify/services/database.dart';
import 'package:flutter/material.dart';
import 'package:polls/polls.dart';
import 'package:intl/intl.dart';

class PollsTile extends StatefulWidget {
  final String creator, pollName, user, pollId, pollDetails;
  final Map usersWhoVoted;
  final int pollNoOfOptions;
  final dynamic pollOptions;
  final dynamic pollOptionsValues;

  const PollsTile({
    Key? key,
    required this.creator,
    required this.pollName,
    required this.usersWhoVoted,
    required this.pollNoOfOptions,
    required this.pollOptions,
    required this.user,
    required this.pollOptionsValues,
    required this.pollId,
    required this.pollDetails
  }) : super(key: key);

  @override
  _PollsTileState createState() => _PollsTileState();
}

class _PollsTileState extends State<PollsTile> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var pollOptionsList = [];
    var pollOptionsValuesList = [];
    List<dynamic> list = [];
    double option1 = (widget.pollOptionsValues[0]).toDouble();
    double option2 = (widget.pollOptionsValues[1]).toDouble();
    double option3 = 0.0;
    double option4 = 0.0;

    for (var i = 0; i < widget.pollNoOfOptions; i++) {
      DateTime e = DateTime.parse(widget.pollOptions[i]);
      DateTime date = DateTime.utc(e.year, e.month, e.day, e.hour, e.minute);
      String finalDate = DateFormat('EEEE').format(date) +
          ' ' +
          date.toString().substring(0, 16);
      pollOptionsList.insert(i, finalDate);
      pollOptionsValuesList.insert(i, widget.pollOptionsValues[i]);
    }

    if (widget.pollNoOfOptions == 2) {
      list = [
        Polls.options(title: (pollOptionsList[0]), value: option1),
        Polls.options(title: (pollOptionsList[1]), value: option2),
      ];
    } else if (widget.pollNoOfOptions == 3) {
      double option3 = (widget.pollOptionsValues[2]).toDouble();
      list = [
        Polls.options(title: (pollOptionsList[0]), value: option1),
        Polls.options(title: (pollOptionsList[1]), value: option2),
        Polls.options(title: (pollOptionsList[2]), value: option3),
      ];
    } else if (widget.pollNoOfOptions == 4) {
      double option3 = (widget.pollOptionsValues[2]).toDouble();
      double option4 = (widget.pollOptionsValues[3]).toDouble();
      list = [
        Polls.options(title: (pollOptionsList[0]), value: option1),
        Polls.options(title: (pollOptionsList[1]), value: option2),
        Polls.options(title: (pollOptionsList[2]), value: option3),
        Polls.options(title: (pollOptionsList[3]), value: option4),
      ];
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white)),
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.pollName,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(widget.pollDetails),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                databaseService.deletePoll(widget.pollId);
              },
            ),
            // tileColor: Colors.black,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0.0, 10.0, 10.0),
            child: Polls(
              children: list,
              question: const Text(
                '',
                  style: TextStyle(
                    fontSize: 1,
                  )
              ),
              currentUser: widget.user,
              creatorID: widget.creator,
              voteData: widget.usersWhoVoted,
              allowCreatorVote: true,
              userChoice: widget.usersWhoVoted[widget.user],
              onVoteBackgroundColor: Colors.blue,
              leadingBackgroundColor: Colors.blue,
              backgroundColor: Colors.white,
              onVote: (choice) {
                setState(() {
                  widget.usersWhoVoted[widget.user] = choice;
                  databaseService.updatePollUser(
                      widget.pollId, widget.usersWhoVoted);
                });
                if (choice == 1) {
                  setState(() {
                    option1 = pollOptionsValuesList[0].toDouble() + 1.0;
                  });
                }
                if (choice == 2) {
                  setState(() {
                    option2 = pollOptionsValuesList[1].toDouble() + 1.0;
                  });
                }
                if (choice == 3) {
                  setState(() {
                    option3 = pollOptionsValuesList[2].toDouble() + 1.0;
                  });
                }
                if (choice == 4) {
                  setState(() {
                    option4 = pollOptionsValuesList[2].toDouble() + 1.0;
                  });
                }
                if (widget.pollNoOfOptions == 2) {
                  databaseService.updatePollData(widget.pollId, [option1, option2]);
                } else if (widget.pollNoOfOptions == 3) {
                  databaseService
                      .updatePollData(widget.pollId, [option1, option2, option3]);
                } else if (widget.pollNoOfOptions == 4) {
                  databaseService.updatePollData(
                      widget.pollId, [option1, option2, option3, option4]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
