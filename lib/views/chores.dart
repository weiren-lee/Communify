import 'package:communify/views/create_chores.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/services/auth.dart';
import 'package:random_string/random_string.dart';

class Chores extends StatefulWidget {
  final String houseId;

  const Chores({Key? key, required this.houseId}) : super(key: key);

  @override
  _ChoresState createState() => _ChoresState();
}

class _ChoresState extends State<Chores> {
  late Stream fileStream;
  late Stream itemStream;
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();

  // List<String> itemName = [];
  TextEditingController itemController = TextEditingController();

  addItemData() async {
    var itemId = randomAlphaNumeric(16);

    Map<String, String> itemMap = {
      "itemId": itemId,
      "itemName": itemController.text,
      "houseId": widget.houseId,
    };

    await databaseService.addItemNameData(itemMap, itemId);
  }

  Future createModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Items Here"),
            content: TextField(
              controller: itemController,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text('Add'),
                onPressed: () {
                  // addToList();
                  addItemData();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  deleteItem(itemId) async {
    print(itemId);
    await databaseService.deleteItemName(itemId);
  }

  Widget choresList() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            const Icon(
              Icons.add,
              color: Colors.transparent,
            ),
            const Text('Chores',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateChores(houseId: widget.houseId)));
                },
                child: const Icon(Icons.notification_add_outlined),
              ),
            ),
            const Spacer(),
          ],
        ),
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
                                choreId:
                                    snapshot.data.docs[index].data()['choreId'],
                                chores: snapshot.data.docs[index]
                                    .data()['choreName'],
                                assignedUser: snapshot.data.docs[index]
                                    .data()['assignedUser'],
                              );
                            }),
                      )
                    ],
                  );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Spacer(),
            const Icon(
              Icons.add,
              color: Colors.transparent,
            ),
            const Text('Items to Buy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  createModal(context);
                },
                child: const Icon(Icons.library_add_outlined),
              ),
            ),
            const Spacer(),
          ],
        ),
        Flexible(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: StreamBuilder(
                    stream: itemStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return snapshot.data.docs.length == 0
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('No items currently'),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              height: 220,
                              child: ListView.builder(
                                  controller:
                                      PageController(viewportFraction: 0.7),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {
                                          deleteItem(snapshot.data.docs[index]
                                              .data()['itemId']);
                                        },
                                        child: ListTile(
                                          title: Text(snapshot.data.docs[index]
                                              .data()['itemName']),
                                        ));
                                  }),
                            );
                    },
                  ),
                )))
      ],
    );
  }

  void addToList() {
    if (itemController.text.isNotEmpty) {
      setState(() {
        [].add(itemController.text);
      });
    }
  }

  @override
  void initState() {
    databaseService.getChoresData(widget.houseId).then((val) {
      setState(() {
        fileStream = val;
      });
    });
    databaseService.getItemName(widget.houseId).then((val) {
      setState(() {
        itemStream = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: choresList(),
    );
  }
}

class ChoresTiles extends StatefulWidget {
  late final String chores;
  late final String assignedUser;
  late final String choreId;

  ChoresTiles(
      {required this.chores,
      required this.assignedUser,
      required this.choreId});

  @override
  State<ChoresTiles> createState() => _ChoresTilesState();
}

class _ChoresTilesState extends State<ChoresTiles> {
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [false, true];
    super.initState();
  }

  DatabaseService databaseService = DatabaseService();
  bool _isLoading = false;

  updateCompletedStatus(choreId, isSelected) async {
    setState(() {
      _isLoading = true;
    });

    await databaseService
        .updateCompletionStatus(choreId, isSelected)
        .then((value) {
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
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black, fontSize: 20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.blueGrey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
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
                        fillColor:
                            isSelected[0] == true ? Colors.green : Colors.red,
                        constraints:
                            const BoxConstraints(minHeight: 10, minWidth: 10),
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
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                              if (isSelected[0] == true) {
                                deleteChores(widget.choreId);
                              }
                            }
                          });
                          updateCompletedStatus(
                              widget.choreId,
                              isSelected[0] == true
                                  ? 'completed'
                                  : 'incomplete');
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
