import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/home.dart';
import 'package:dexter_health/views/widgets/buttons.dart';
import 'package:dexter_health/views/widgets/drop_down_text_field.dart';
import 'package:dexter_health/views/widgets/text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResgisterNurse extends StatefulHookWidget {
  const ResgisterNurse({Key? key}) : super(key: key);
  static const String id = 'resgister_nurse';

  @override
  State<ResgisterNurse> createState() => _ResgisterNurseState();
}

class _ResgisterNurseState extends State<ResgisterNurse> {
  final fb = FirebaseDatabase.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var ref;
  @override
  void initState() {
    ref = fb.ref().child('nurses');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nurseName = useTextEditingController();
    final nurseGender = useTextEditingController();
    final nurseShift = useTextEditingController();
    final pickedNurseShift = useState("");
    final pickedNurseGender = useState("");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add nurse",
          style: TextStyle(
              color: white, fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            TextFieldWidget(
              hintText: "Nurse name",
              controller: nurseName,
            ),
           
            CustomTextFieldDropDown(
             hintText: "Nurse gender",
              controller: nurseGender,
              onTap: () {
                showModalSheet(
                    context: context,
                    items: ["Female","Male", "Prefer not to say"],
                    callBack: ((value) {
                      nurseGender.text = pickedNurseGender.value = value;
                    }));
              },
            ),
            CustomTextFieldDropDown(
              hintText: "Nurse shift",
              controller: nurseShift,
              onTap: () {
                showModalSheet(
                    context: context,
                    items: ["Morning","Afternoon", "Night"],
                    callBack: ((value) {
                      nurseShift.text = pickedNurseShift.value = value;
                    }));
              },
            ),
           
            const SizedBox(
              height: 16,
            ),
            AppButton(
              buttonText: "Register nurse",
              onPressed: () async {
                var id = DateTime.now().microsecondsSinceEpoch.toString();
                if (nurseGender.text.isNotEmpty &&
                    nurseName.text.isNotEmpty &&
                    nurseShift.text.isNotEmpty) {
                  ref.push().set({
                    "id": id,
                    "name": nurseName.text,
                    "gender": nurseGender.text,
                    "nurseShift": nurseShift.text,
                    "timeCreated": DateTime.now().toIso8601String()
                  }).asStream();
                  final SharedPreferences prefs = await _prefs;
                  await prefs.setString("id", id.toString());
                 Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.id, (Route<dynamic> route) => false);
                } else {
                  showFlush("Please fill all fields", red, context);
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
