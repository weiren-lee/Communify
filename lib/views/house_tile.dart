import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/router_page.dart';
import 'package:flutter/material.dart';

class HouseTile extends StatefulWidget {
  final String houseId;
  final String houseName;
  final String housePassword;

  const HouseTile({Key? key, required this.houseId, required this.houseName, required this.housePassword})
      : super(key: key);

  @override
  _HouseTileState createState() => _HouseTileState();
}

class _HouseTileState extends State<HouseTile> {
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  TextEditingController houseController = TextEditingController();

  Future checkPasswordModal(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter House Password"),
            content: TextField(
              controller: houseController,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: const Text('Enter'),
                onPressed: () {
                  // addToList();
                  // addItemData();
                  print(houseController.text);
                  print(widget.housePassword);
                  if (houseController.text == widget.housePassword) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RouterPage(houseId: widget.houseId)));
                                }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            checkPasswordModal(context),
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             RouterPage(houseId: widget.houseId)))
          },
        ),
      ),
    );
  }
}
