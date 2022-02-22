import 'package:cached_network_image/cached_network_image.dart';
import 'package:communify/views/create_chores.dart';
import 'package:communify/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/create_feed.dart';
import 'package:communify/services/auth.dart';
import 'package:flutter/foundation.dart';

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


  chores = [1, "hello"]


  Widget choresList() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: 160,
            decoration: BoxDecoration(
              color: Colors.orange[100],
            ),
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.7),
                itemCount: chores.length,
                itemBuilder: (context, index) {
                  return choresTile();
                }
            ),
          )
        ],
      )
    );
  }


  @override
  void initState() {
    databaseService.getFeedData(widget.houseId).then((val){
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
              MaterialPageRoute(builder: (context) => createChores(houseId: widget.houseId)));
        },
      ),

    );
  }
}

class choresTile extends StatelessWidget {
  const choresTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('hello'.toUpperCase()),
                    Container(
                      width: 200,
                      child: Text(
                        chores.title.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
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
