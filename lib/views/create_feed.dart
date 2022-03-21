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
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateFeed extends StatefulWidget {
  final String houseId;

  const CreateFeed({Key? key, required this.houseId}) : super(key: key);

  @override
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
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
      var urlDownload = "";
      if (image != null) {
        final fileName = basename(image!.path);
        final destination = 'files/$fileName';
        task = FirebaseApi.uploadFile(destination, image!);
        final snapshot = await task!.whenComplete(() {});
        urlDownload = await snapshot.ref.getDownloadURL();
      };


      Map<String, String> feedMap = {
        "feedId": feedId,
        "feedImageUrl": urlDownload,
        "feedDescription": feedDescription,
        "name": authService.getUserName(),
        "datetime": datetime,
        "houseId": widget.houseId,
        "profilePic": authService.getProfilePicture() ?? 'https://pic.onlinewebfonts.com/svg/img_568656.png',
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
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    createFeedOnline();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                    "Create Post",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FormBuilder(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                        const SizedBox(height: 20,),
                        FormBuilderTextField(
                          name: "title",
                          minLines: 1,
                          maxLines: 5,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'Must not be nil'),
                          ]),
                          decoration: const InputDecoration(
                            hintText: "Write your thoughts here...",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.chat_bubble_outline),
                          ),
                          onChanged: (val) {
                            feedDescription = val!;
                          },
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 15,
                        ),
                        image != null
                            ? Image.file(image!,
                                width: 400, height: 400, fit: BoxFit.cover)
                            : Container(),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                ),
                                onPressed: () => pickImage(ImageSource.camera),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.photo_camera, size: 20),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Take a Picture',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white))
                                  ],
                                )),
                            const Spacer(),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                ),
                                onPressed: () => pickImage(ImageSource.gallery),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.image, size: 20),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('From Library',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white))
                                  ],
                                )),
                          ],
                        ),],
                      ),
                    ]),
                ),
              ));
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
