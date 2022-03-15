import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addHouseData(
      Map<String, dynamic> houseMap, String houseId) async {
    await FirebaseFirestore.instance
        .collection("house")
        .doc(houseId)
        .set(houseMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getHouseData() async {
    return await FirebaseFirestore.instance.collection("house").snapshots();
  }

  getEventsData(houseId) async {
    return await FirebaseFirestore.instance
        .collection('events')
        .where('houseId', isEqualTo: houseId)
        .snapshots();
  }

  Future<void> addData(Map<String, dynamic> feedData, String feedId) async {
    await FirebaseFirestore.instance
        .collection("feed")
        .doc(feedId)
        .set(feedData)
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteFeed(feedId) async {
    await FirebaseFirestore.instance.collection('feed').doc(feedId).delete();
  }

  Future<void> addChoresData(
      Map<String, dynamic> choreData, String choreId) async {
    await FirebaseFirestore.instance
        .collection("chores")
        .doc(choreId)
        .set(choreData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getFeedData(houseId) async {
    return await FirebaseFirestore.instance
        .collection("feed")
        .where('houseId', isEqualTo: houseId)
        .snapshots();
    QuerySnapshot response2 = FirebaseFirestore.instance
        .collection("user")
        .snapshots() as QuerySnapshot<Object?>;
  }

  getChoresData(houseId) async {
    return await FirebaseFirestore.instance
        .collection("chores")
        .where('houseId', isEqualTo: houseId)
        .snapshots();
  }

  getChoresStatus(choreId) async {
    return await FirebaseFirestore.instance
        .collection('chores')
        .doc(choreId)
        .get();
  }

  deleteChores(choreId) async {
    await FirebaseFirestore.instance.collection('chores').doc(choreId).delete();
  }

  Future<void> addItemNameData(
      Map<String, dynamic> itemData, String itemId) async {
    await FirebaseFirestore.instance
        .collection("items")
        .doc(itemId)
        .set(itemData)
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteItemName(itemId) async {
    await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
  }

  getItemName(houseId) async {
    return await FirebaseFirestore.instance
        .collection('items')
        .where('houseId', isEqualTo: houseId)
        .snapshots();
  }

  updateItemStatus(itemId, bought) async {
    FirebaseFirestore.instance
        .collection('items')
        .doc(itemId)
        .update({"bought": bought}).whenComplete(() async {
    }).catchError((e) => print(e));
  }

  Future<void> addUserData(Map<String, dynamic> userData, String userId) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateHouseUsers(houseId, username) async {
    FirebaseFirestore.instance.collection("house").doc(houseId).update({
      "users": FieldValue.arrayUnion([username])
    }).whenComplete(() async {
      print("name added to house");
    }).catchError((e) => print(e));
  }

  updateCompletionStatus(choreId, isSelected) async {
    FirebaseFirestore.instance
        .collection("chores")
        .doc(choreId)
        .update({"status": isSelected}).whenComplete(() async {
      print("completed? set to" + isSelected);
    }).catchError((e) => print(e));
  }

  getUid(username) async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isEqualTo: username)
        .get();
    final allData = qSnap.docs.map((doc) => doc.data()).toList();
    var userDetails = allData[0] as Map;
    String userId = userDetails['userId'];
    return userId;
  }

  getHouseUsers(houseId) async {
    return await FirebaseFirestore.instance
        .collection("house")
        .where('houseId', isEqualTo: houseId)
        .snapshots();
  }

  Future<void> addEventData(
      Map<String, dynamic> eventData, String eventId) async {
    await FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .set(eventData)
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteEvent(eventId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  }

  Future<void> addPolData(Map<String, dynamic> pollData, String pollId) async {
    await FirebaseFirestore.instance
        .collection("polls")
        .doc(pollId)
        .set(pollData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getPollData(houseId) async {
    return await FirebaseFirestore.instance
        .collection("polls")
        .where('houseId', isEqualTo: houseId)
        .snapshots();
  }

  updatePollData(pollId, option) async {
    FirebaseFirestore.instance
        .collection("polls")
        .doc(pollId)
        .update({"pollOptionsValues": option}).whenComplete(() async {
      print("pollOptionsValues updated");
    }).catchError((e) => print(e));
  }

  updatePollUser(pollId, userMap) async {
    FirebaseFirestore.instance
        .collection("polls")
        .doc(pollId)
        .update({"usersWhoVoted": userMap}).whenComplete(() async {
      print("usersWhoVoted updated");
    }).catchError((e) => print(e));
  }

  deletePoll(pollId) async {
    await FirebaseFirestore.instance.collection('polls').doc(pollId).delete();
  }
}
