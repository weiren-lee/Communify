import 'package:cached_network_image/cached_network_image.dart';
import 'package:communify/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/create_feed.dart';
import 'package:communify/services/auth.dart';
import 'package:flutter/foundation.dart';

class Home extends StatefulWidget {

  final String houseId;

  const Home({Key? key, required this.houseId}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService = AuthService();

  late Stream fileStream;
  DatabaseService databaseService = DatabaseService();

  Widget feedList() {
    return Container(
      child: StreamBuilder(
        stream: fileStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return FeedTile(
                  imgUrl:
                  snapshot.data.docs[index].data()['feedImageUrl'],
                  desc:
                  snapshot.data.docs[index].data()['feedDescription'],
                  name:
                  snapshot.data.docs[index].data()['name'],
                  datetime:
                  snapshot.data.docs[index].data()['datetime'],
                );
              });
        },
      ),
    );
  }


  @override
  void initState() {
    databaseService.getFeedData(widget.houseId).then((val) {
      setState(() {
        fileStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: feedList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => CreateFeed(houseId: widget.houseId)));
        },
      ),

    );
  }
}

class FeedTile extends StatelessWidget {
  late final String imgUrl;
  late final String desc;
  late final String name;
  late final String datetime;

  FeedTile(
      {required this.imgUrl, required this.desc, required this.name, required this.datetime});

  final String currentDateTime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    var printDateTime = (currentDateTime.substring(0, 4) ==
        datetime.substring(0, 4)) ?
    (currentDateTime.substring(5, 7) == datetime.substring(5, 7)) ?
    (currentDateTime.substring(8, 10) == datetime.substring(8, 10)) ?
    (currentDateTime.substring(11, 13) == datetime.substring(11, 13)) ?
    (currentDateTime.substring(14, 16) == datetime.substring(14, 16)) ?
    (currentDateTime.substring(17, 19) == datetime.substring(17, 19))
        ? 'just posted'
        : 'a few seconds ago'
        : (int.parse(currentDateTime.substring(14, 16)) -
        int.parse(datetime.substring(14, 16))).toString() == '1' ? (int.parse(
        currentDateTime.substring(14, 16)) -
        int.parse(datetime.substring(14, 16))).toString() + ' min ago ' : (int
        .parse(currentDateTime.substring(14, 16)) -
        int.parse(datetime.substring(14, 16))).toString() + ' mins ago '
        : (int.parse(currentDateTime.substring(11, 13)) -
        int.parse(datetime.substring(11, 13))).toString() == '1' ? (int.parse(
        currentDateTime.substring(11, 13)) -
        int.parse(datetime.substring(11, 13))).toString() + ' hour ago ' : (int
        .parse(currentDateTime.substring(11, 13)) -
        int.parse(datetime.substring(11, 13))).toString() + ' hours ago '
        : (int.parse(currentDateTime.substring(8, 10)) -
        int.parse(datetime.substring(8, 10))).toString() == '1' ? (int.parse(
        currentDateTime.substring(8, 10)) -
        int.parse(datetime.substring(8, 10))).toString() + ' day ago ' : (int
        .parse(currentDateTime.substring(8, 10)) -
        int.parse(datetime.substring(8, 10))).toString() + ' days ago '
        : (int.parse(currentDateTime.substring(5, 7)) -
        int.parse(datetime.substring(5, 7))).toString() == '1' ? (int.parse(
        currentDateTime.substring(5, 7)) - int.parse(datetime.substring(5, 7)))
        .toString() + ' month ago ' : (int.parse(
        currentDateTime.substring(5, 7)) - int.parse(datetime.substring(5, 7)))
        .toString() + ' months ago '
        : (int.parse(currentDateTime.substring(0, 4)) -
        int.parse(datetime.substring(0, 4))).toString() == '1' ? (int.parse(
        currentDateTime.substring(0, 4)) - int.parse(datetime.substring(0, 4)))
        .toString() + ' year ago ' : (int.parse(
        currentDateTime.substring(0, 4)) - int.parse(datetime.substring(0, 4)))
        .toString() + ' years ago ';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // start of post header
                Row(
                  children: [
                    // to link profile pic later
                    const ProfileAvatar(
                        imageUrl: 'https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg'),
                    // change to profile pic
                    const SizedBox(width: 8.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(
                              fontWeight: FontWeight.w600),),
                          Row(children: [
                            Text(printDateTime,
                                style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12.0,)),
                            Icon(Icons.public, color: Colors.grey[600],
                              size: 12.0,)
                          ],)
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => const Text('More'),
                        icon: const Icon(Icons.more_horiz))
                  ],
                ),
                // end of post header
                const SizedBox(height: 3.5,),
                // post description
                Text(desc),
                imgUrl != '' ? const SizedBox.shrink() : const SizedBox(
                    height: 6.0),
              ],
            ),
          ),
          imgUrl != '' ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CachedNetworkImage(imageUrl: imgUrl,),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
