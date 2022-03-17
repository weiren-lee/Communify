import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:communify/services/firebase_api.dart';
import 'dart:io';
import 'package:communify/services/auth.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  AuthService authService = AuthService();

  File? image;
  File? file;
  UploadTask? task;


  updateDetails() async{
    if(_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      var urlDownload = "";
      var displayName = "";
      displayName = _formKey.currentState!.value['username'];

      if (image != null) {
        final fileName = basename(image!.path);
        final destination = 'profile/$fileName';
        task = FirebaseApi.uploadFile(destination, image!);
        final snapshot = await task!.whenComplete(() {});
        urlDownload = await snapshot.ref.getDownloadURL();
      }

      await authService.updateProfile(urlDownload, displayName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var username = authService.getUserName();
    var currentPP = authService.getProfilePicture();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
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
                  updateDetails();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ),
          )
        ],
      ),
      body:
        FormBuilder(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              pickImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.photo_camera_outlined, size: 32),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 88,
                              backgroundColor: Colors.blueGrey,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 160.0,
                                  height: 160.0,
                                  child: image != null
                                      ? Image.file(image!,
                                      width: 160, height: 160, fit: BoxFit.fill)
                                      : (currentPP != null ?
                                  CircleAvatar(backgroundImage: CachedNetworkImageProvider(currentPP),)
                                      : Image.network(
                                    "https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg",
                                    fit: BoxFit.fill,
                                  ))
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              pickImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo_library_outlined, size: 32),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      FormBuilderTextField(
                        name: "username",
                        initialValue: username,
                        maxLines: 1,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: const InputDecoration(
                          hintText: "Username",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.chat_bubble_outline),
                        ),
                      ),
                      const Divider(),
                      // FormBuilderDateTimePicker(
                      //   name: "birthday",
                      //   maxLines: 1,
                      //   decoration: const InputDecoration(
                      //     hintText: "Birthday (optional)",
                      //     border: InputBorder.none,
                      //     prefixIcon: Icon(Icons.cake_outlined),
                      //   ),
                      // ),
                    ],
                  ),
                ]),
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
