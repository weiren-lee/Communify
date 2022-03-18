import 'package:cached_network_image/cached_network_image.dart';
import 'package:communify/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:communify/services/database.dart';
import 'package:communify/views/create_feed.dart';
import 'package:communify/services/auth.dart';

class Home extends StatefulWidget {

  final String houseId;

  const Home({Key? key, required this.houseId}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Stream fileStream;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

  Widget feedList() {
    return StreamBuilder(
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
                feedId:
                  snapshot.data.docs[index].data()['feedId'],
                profilePic:
                  snapshot.data.docs[index].data()['profilePic'],
              );
            });
      },
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
    var currentUser = authService.getUserName();
    var currentUserPP = authService.getProfilePicture();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10.0,),
          Row(
            children: [
              const SizedBox(width: 15.0,),
              ProfileAvatar(imageUrl: currentUserPP),
              const SizedBox(width: 10,),
              Text(
                'Welcome Back, ' + currentUser + '!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.blueGrey),
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => CreateFeed(houseId: widget.houseId)));
                },
                child: const Text(
                  "New Post",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),),
              const Spacer(),

            ],
          ),
          const SizedBox(height: 10.0,),
          Expanded(child: feedList()),
        ],
      ),
    );
  }
}

class FeedTile extends StatelessWidget {
  late final String imgUrl;
  late final String desc;
  late final String name;
  late final String datetime;
  late final String feedId;
  late final String profilePic;

  FeedTile({required this.imgUrl, required this.desc, required this.name, required this.datetime, required this.feedId, required this.profilePic});

  final String currentDateTime = DateTime.now().toString();
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();

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

    deleteFeed(feedId) async {
      await databaseService.deleteFeed(feedId);
    }
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
                Row(
                  children: [
                    ProfileAvatar(imageUrl: profilePic),
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
                    IconButton(
                        onPressed: () => {
                          deleteFeed(feedId)
                        },
                        icon: const Icon(Icons.delete_outline))
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
