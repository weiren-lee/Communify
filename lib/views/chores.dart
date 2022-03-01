import 'package:cached_network_image/cached_network_image.dart';
import 'package:communify/views/create_chores.dart';
import 'package:communify/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/create_feed.dart';
import 'package:communify/services/auth.dart';

class Chores extends StatefulWidget {

  final String houseId;
  const Chores({Key? key, required this.houseId}) : super(key: key);

  @override
  _ChoresState createState() => _ChoresState();
}

class _ChoresState extends State<Chores> {
  AuthService authService = AuthService();

  late Stream fileStream;
  DatabaseService databaseService = DatabaseService();

  Widget choresList() {
    return Column(
      children: [
        const Text('Chores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        StreamBuilder(
          stream: fileStream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.data == null
                ? const Text('No Data Available')
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
  ChoresTiles({required this.chores, required this.assignedUser});

  @override
  State<ChoresTiles> createState() => _ChoresTilesState();
}

class _ChoresTilesState extends State<ChoresTiles> {
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
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
                ],                ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Task: ' + widget.chores,
                    style: const TextStyle(fontSize: 20),
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
                            }
                          });
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
