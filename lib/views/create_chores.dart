import 'package:communify/views/create_chores_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateChores extends StatefulWidget {
  final dynamic houseId;

  const CreateChores({Key? key, required this.houseId}) : super(key: key);

  @override
  _CreateChoresState createState() => _CreateChoresState();
}

class _CreateChoresState extends State<CreateChores> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late String choreName;
  List<String> names = [];
  List noOfOptions = [1, 2, 3, 4, 5, 6];
  var randomiserNoOfOptions;

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateChoresTwo(
                                houseId: widget.houseId,
                                choreName: choreName,
                                randomiserNoOfOptions: randomiserNoOfOptions ?? 2,
                              )));
                }
              },
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          //add event form
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: 'Must not be nil'),
                  ]),
                  decoration: const InputDecoration(
                    hintText: "Chore Name",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (val) {
                    choreName = val!;
                  },
                ),
                const Divider(),
                FormBuilderDropdown(
                  name: 'options',
                  decoration: const InputDecoration(
                    labelText: 'No. of People to Randomise',
                  ),
                  allowClear: true,
                  initialValue: 2,
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  items: noOfOptions
                      .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text('$val'),
                  ))
                      .toList(),
                  onChanged: (val) {
                    randomiserNoOfOptions = val!;
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
