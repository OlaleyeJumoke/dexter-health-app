import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/home.dart';
import 'package:dexter_health/views/widgets/buttons.dart';
import 'package:dexter_health/views/widgets/drop_down_text_field.dart';
import 'package:dexter_health/views/widgets/text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodo extends HookWidget {
  static const String id = 'add_todo';

  TextEditingController title = TextEditingController();

  final fb = FirebaseDatabase.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos');
    final todo = useTextEditingController();
    final time = useTextEditingController();
    final resident = useTextEditingController();
    final shift = useTextEditingController();
    final nurseShift = useTextEditingController();
    final pickedNurseShift = useState("");
    final pickedResident = useState("");
    final pickedTime = useState("");

    Future<void> selectDate() async {
      final TimeOfDay? picked = await showTimePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: appColor, // header background color
                onPrimary: Colors.white, // header text color
                onSurface: appColor, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        var result = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        var result1 = DateFormat("d/MMM/yyyy. hh:mm a").format(result);
        time.text = result1;
        print(result);
        pickedTime.value = result.toIso8601String();
        print(result.toIso8601String());

      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todos"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(hintText: "Write todo", controller: todo),
            CustomTextFieldDropDown(
              hintText: "Shift",
              controller: nurseShift,
              onTap: () {
                showModalSheet(
                    context: context,
                    items: ["Morning", "Afternoon", "Night"],
                    callBack: ((value) {
                      nurseShift.text = pickedNurseShift.value = value;
                    }));
              },
            ),
            CustomTextFieldDropDown(
              hintText: "Resident",
              controller: resident,
              onTap: () {
                showModalSheet(
                    context: context,
                    items: ["Female", "Male", "Prefer not to say"],
                    callBack: ((value) {
                      resident.text = pickedResident.value = value;
                    }));
              },
            ),
            TextFieldWidget(
              hintText: "Time to execute",
              controller: time,
              readOnly: true,
              onTap: () {
                printOnlyInDebug("message");
                selectDate();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
                onPressed: () async {
                  if (resident.text.isNotEmpty &&
                      todo.text.isNotEmpty &&
                      time.text.isNotEmpty &&
                      nurseShift.text.isNotEmpty) {
                    final SharedPreferences prefs = await _prefs;
                    var nurseId = prefs.getString("id");
                    var id = DateTime.now().microsecondsSinceEpoch.toString();

                    ref.push().set({
                      "todo": todo.text,
                      "todoId": id,
                      "nurseID": nurseId,
                      "residentId": resident.text,
                      "timeToExecute": pickedTime.value,
                      "createdAt": DateTime.now().toIso8601String(),
                      "completed": false
                    }).asStream();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const Home()));
                  } else {
                    showFlush("Please fill all fields", red, context);
                  }
                },
                buttonText: "Add todo")
          ],
        ),
      ),
    );
  }
}
