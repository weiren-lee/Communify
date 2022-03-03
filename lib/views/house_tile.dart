import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/router_page.dart';
import 'package:flutter/material.dart';

class HouseTile extends StatefulWidget {
  final String houseId;
  final String houseName;

  const HouseTile({Key? key, required this.houseId, required this.houseName})
      : super(key: key);

  @override
  _HouseTileState createState() => _HouseTileState();
}

class _HouseTileState extends State<HouseTile> {
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

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
              databaseService.updateHouseUsers(
                  widget.houseId, authService.getUserName()),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RouterPage(houseId: widget.houseId)))
            },
          ),
        ),
      ),
    );
  }
}
