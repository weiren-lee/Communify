import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/router_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseTile extends StatefulWidget {
  final String houseId;
  final String houseName;

  const HouseTile({Key? key, required this.houseId, required this.houseName}) : super(key: key);

  @override
  _HouseTileState createState() => _HouseTileState();
}

class _HouseTileState extends State<HouseTile> {
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  // tried to get uid to assign hid to uid but cannot work due to typing issues
  // Future<dynamic> getUid() async {
  //   String username = authService.getUserName();
  //   await databaseService.getUid(username).then((value) {
  //     setState(() {
  //       var userId = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          child: ListTile(
            leading: const Icon(
              Icons.home,
              size: 38,
            ),
            title: Text(widget.houseName),
            subtitle: Text("Id: " + widget.houseId),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => {

              // databaseService.updateUserHouse(getUid(), widget.houseId),
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RouterPage(houseId: widget.houseId))
              )
            },
          ),
        ),
      ),
    );
  }
}

