import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/widgets/buttons.dart';
import 'package:dexter_health/views/widgets/text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddResident extends StatefulHookWidget {
  static const String id = 'add_resident';

  const AddResident({Key? key}) : super(key: key);

  @override
  State<AddResident> createState() => _AddResidentState();
}

class _AddResidentState extends State<AddResident> {
  final fb = FirebaseDatabase.instance;
  var ref;
  @override
  void initState() {
    ref = fb.ref().child('residents');
    super.initState();
  }

//TextEditingController residentName = Text
  @override
  Widget build(BuildContext context) {
    final residentName = useTextEditingController();
    final residentSpecialNeed = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Resident"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            TextFieldWidget(
              controller: residentName,
              hintText: "Resident Name",
              validator: ((p0) => null),
            ),
            TextFieldWidget(
              controller: residentSpecialNeed,
              hintText: "Resident's special need or ailment",
              validator: ((p0) => null),
            ),
            const SizedBox(
              height: 16,
            ),
            AppButton(
                onPressed: () {
                  if (residentName.text.isNotEmpty &&
                      residentSpecialNeed.text.isNotEmpty) {
                    printOnlyInDebug("message");
                    var id = DateTime.now().microsecondsSinceEpoch.toString();
                    ref.push().set({
                      "name": residentName.text,
                      "special_need": residentSpecialNeed.text,
                      "residentId": id,
                      "timeCreated": DateTime.now().toIso8601String()
                    }).asStream();
                    residentName.clear();
                    residentSpecialNeed.clear();
                    showFlush("Resident added!!", green, context);
                  } else {
                    showFlush("Please fill all fields", red, context);
                  }
                },
                buttonText: "Add resident")
          ],
        ),
      ),
    );
  }
}
