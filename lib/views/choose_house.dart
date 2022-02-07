import 'package:communify/views/create_house.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:communify/services/database.dart';
import 'package:flutter/foundation.dart';
import 'house_tile.dart';

class chooseHouse extends StatefulWidget {
  const chooseHouse({Key? key}) : super(key: key);

  @override
  _chooseHouseState createState() => _chooseHouseState();
}

class _chooseHouseState extends State<chooseHouse> {
  late Stream houseStream;
  DatabaseService databaseService = DatabaseService();

  Widget houseList() {
    return StreamBuilder(
      stream: houseStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return HouseTile(
                      houseId: snapshot.data.docs[index].data()['houseId'],
                      houseName: snapshot.data.docs[index].data()['houseName']);
                },
        );
      },
    );
  }

  @override
  void initState() {
    databaseService.getHouseData().then((val) {
      setState(() {
        houseStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black87),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: houseList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => createHouse()));
        },
      ),
    );
  }
}
