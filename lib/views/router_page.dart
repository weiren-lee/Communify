import 'package:communify/services/auth.dart';
import 'package:communify/views/chores.dart';
import 'package:communify/views/home.dart';
import 'package:communify/views/signin.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouterPage extends StatefulWidget {
  final String houseId;

  const RouterPage({Key? key, required this.houseId}) : super(key: key);

  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    return Scaffold(
        appBar: AppBar(
            title: appBar(context),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              GestureDetector(
                  onTap: () {
                    authService.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  },
                  child: logoutButton(context))
            ]),
        body: IndexedStack(
          index: currentIndex,
          children: [
            Home(houseId: widget.houseId),
            Chores(
              houseId: widget.houseId,
            ),
            const Center(
                child: Text(
              'Calendar',
              style: TextStyle(fontSize: 50),
            )),
            const Center(
                child: Text(
              'Settings',
              style: TextStyle(fontSize: 50),
            )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            // type: BottomNavigationBarType.fixed,
            // backgroundColor: Colors.blue,
            // selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Feed',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.ballot),
                label: 'Chores',
                backgroundColor: Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.grey,
              ),
            ]));
  }
}
