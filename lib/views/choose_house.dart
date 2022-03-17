import 'package:communify/views/create_house.dart';
import 'package:communify/views/settings.dart';
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
                      houseName: snapshot.data.docs[index].data()['houseName'],
                    housePassword: snapshot.data.docs[index].data()['housePassword']
                  );
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
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black87),
          systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Settings())
                    );
                  },
                  child: SizedBox(
                    width: 50.0,
                    height: 45.0,
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(Icons.settings, color: Colors.white,)),)
              )
            ]
        ),
        body: houseList(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              elevation: 0,
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateHouse()));
              },
              child: const Icon(Icons.add,
                  size:30)
          )
      ),
    );
  }
}
