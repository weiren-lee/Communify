import 'package:communify/services/auth.dart';
import 'package:communify/services/database.dart';
import 'package:communify/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:communify/services/firebase_api.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CreateHouse extends StatefulWidget {
  const CreateHouse({Key? key}) : super(key: key);

  @override
  _CreateHouseState createState() => _CreateHouseState();
}

class _CreateHouseState extends State<CreateHouse> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String houseId, houseName, housePassword;
  DatabaseService databaseService = DatabaseService();
  AuthService authService = AuthService();
  bool _isLoading = false;
  File? image;
  File? file;
  UploadTask? task;

  createHouseOnline() async {
    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('house').get();
    final int houseCount = qSnap.docs.length;
    var houseIdInt = houseCount + 1;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> houseMap = {
        "houseId": houseIdInt.toString(),
        "houseName": houseName,
        "housePassword": housePassword,
      };

      await databaseService
          .addHouseData(houseMap, houseIdInt.toString())
          .then((value) {
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
                    createHouseOnline();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Create House",
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
                  child: Column(
                    children: [
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
                                        : const Icon(Icons.house)
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
                      const SizedBox(
                        height: 15,
                      ),
                      FormBuilderTextField(
                        name: 'name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: const InputDecoration(
                          hintText: "House Name",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.house),
                        ),
                        onChanged: (val) {
                          houseName = val!;
                        },
                      ),
                      const Divider(),

                      FormBuilderTextField(
                        name: 'password',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Must not be nil'),
                        ]),
                        decoration: const InputDecoration(
                          hintText: "House Password",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.password),
                        ),
                        onChanged: (val) {
                          housePassword = val!;
                        },
                      ),
                      const Divider(),
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
