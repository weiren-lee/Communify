import 'dart:io';
import 'package:communify/services/firebase_api.dart';
import 'package:path/path.dart';
import 'package:communify/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:communify/services/database.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CreateFeed extends StatefulWidget {
  final String houseId;
  const CreateFeed({Key? key, required this.houseId}) : super(key: key);

  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  final _formKey = GlobalKey<FormState>();
  late String feedImageUrl, feedDescription, feedId, name, houseId;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  String datetime = DateTime.now().toString();
  bool _isLoading = false;
  File? file;
  UploadTask? task;
  File? image;

  createFeedOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      feedId = randomAlphaNumeric(16);

      // for image
      if (image == null) return;

      final fileName = basename(image!.path);
      final destination = 'files/$fileName';

      task = FirebaseApi.uploadFile(destination, image!);

      if (task ==null) return;

      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();


      Map<String, String> feedMap = {
        "feedId": feedId,
        "feedImageUrl": urlDownload,
        "feedDescription": feedDescription,
        "name": authService.getUserName(),
        "datetime": datetime,
        "houseId": widget.houseId,
      };

      await databaseService.addData(feedMap, feedId).then((value) {
        setState(() {
          _isLoading = false;

        });
      });
    }
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
        body: _isLoading
          ? const Center(
            child: CircularProgressIndicator(),
          )
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter your thoughts here" : null,
                      decoration: const InputDecoration(
                        hintText: "Write post here...",
                      ),
                      onChanged: (val) {
                        feedDescription = val;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    image != null
                        ? Image.file(
                            image!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover)
                        : Container(),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        ElevatedButton(onPressed: () => pickImage(ImageSource.camera), child: Row(mainAxisSize: MainAxisSize.min, children:const [
                          Icon(Icons.photo_camera, size: 20),
                          SizedBox(width: 10,),
                          Text('Take a Picture', style: TextStyle(fontSize: 16, color: Colors.white))
                        ],)),
                        const Spacer(),
                        ElevatedButton(onPressed: () => pickImage(ImageSource.gallery), child: Row(mainAxisSize: MainAxisSize.min, children:const [
                          Icon(Icons.image, size: 20),
                          SizedBox(width: 10,),
                          Text('From Library', style: TextStyle(fontSize: 16, color: Colors.white))
                        ],)),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          createFeedOnline();
                        },
                        child: blueButton(context, "Post Me")),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}

