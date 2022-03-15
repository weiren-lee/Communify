import 'package:communify/views/create_house.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/services/database.dart';
import 'house_tile.dart';

class ChooseHouse extends StatefulWidget {
  const ChooseHouse({Key? key}) : super(key: key);

  @override
  _ChooseHouseState createState() => _ChooseHouseState();
}

class _ChooseHouseState extends State<ChooseHouse> {
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: appBar(context),
          backgroundColor: const Color(0xAA3385c6),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black87),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: houseList(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateHouse()));
          },
        ),
      ),
    );
  }
}
