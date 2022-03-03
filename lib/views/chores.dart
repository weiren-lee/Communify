import 'package:communify/views/create_chores.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/services/auth.dart';

class Chores extends StatefulWidget {
  final String houseId;
  const Chores({Key? key, required this.houseId}) : super(key: key);

  @override
  _ChoresState createState() => _ChoresState();
}

class _ChoresState extends State<Chores> {
  late Stream fileStream;
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  Widget choresList() {
    return Column(
      children: [
        const Center(child: Text('Chores', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        StreamBuilder(
          stream: fileStream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.data.docs.length == 0
                ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No chores remaining :D'),
                )
                : Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  height: 160,
                  child: PageView.builder(
                      controller: PageController(viewportFraction: 0.7),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return ChoresTiles(
                          choreId: snapshot.data.docs[index].data()['choreId'],
                          chores: snapshot.data.docs[index].data()['choreName'],
                          assignedUser: snapshot.data.docs[index].data()['assignedUser'],
                        );
                      }
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }


  @override
  void initState() {
    databaseService.getChoresData(widget.houseId).then((val){
      setState(() {
        fileStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: choresList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateChores(houseId: widget.houseId)));
        },
      ),
    );
  }
}

class ChoresTiles extends StatefulWidget {
  late final String chores;
  late final String assignedUser;
  late final String choreId;
  ChoresTiles({required this.chores, required this.assignedUser, required this.choreId});

  @override
  State<ChoresTiles> createState() => _ChoresTilesState();
}

class _ChoresTilesState extends State<ChoresTiles> {
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [false,true];
    super.initState();
  }

  DatabaseService databaseService = DatabaseService();
  bool _isLoading = false;

  updateCompletedStatus(choreId, isSelected) async {
    setState(() {
      _isLoading = true;
    });

    await databaseService.updateCompletionStatus(choreId, isSelected).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  getStatus(choreId) async {
    await databaseService.getChoresStatus(choreId).then((value) {
      bool toggle;
      toggle = (value['status'] == 'completed') ? true : false;
      return toggle;
    });
  }

  deleteChores(choreId) async {
    await databaseService.deleteChores(choreId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black, fontSize: 20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                      Chip(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.transparent,
                        label: Text(
                          widget.chores,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        onDeleted: () async {
                          deleteChores(widget.choreId);
                        },
                      ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Assignee: ' + widget.assignedUser,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      const Text(
                          'Completed? ',
                        style: TextStyle(fontSize: 16),
                      ),
                      ToggleButtons(
                        borderColor: Colors.black,
                        fillColor: isSelected[0] == true ? Colors.green : Colors.red,
                        constraints: const BoxConstraints(minHeight: 10, minWidth: 10),
                        borderWidth: 2,
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Yes',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Nope',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int i=0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                              if (isSelected[0] == true) {
                                deleteChores(widget.choreId);
                              }
                            }
                          });
                          updateCompletedStatus(widget.choreId, isSelected[0] == true? 'completed' : 'incomplete');
                        },
                        isSelected: isSelected,
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}