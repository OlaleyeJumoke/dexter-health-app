import 'dart:convert';

import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/home.dart';
import 'package:dexter_health/views/widgets/buttons.dart';
import 'package:dexter_health/views/widgets/drop_down_text_field.dart';
import 'package:dexter_health/views/widgets/text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodo extends StatefulHookWidget {
  static const String id = 'add_todo';

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController title = TextEditingController();

  final fb = FirebaseDatabase.instance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var ref;
  var refResident;
  var res;
  @override
  void initState() {
    ref = fb.ref().child('todos');
    getResidents();
    // TODO: implement initState
    super.initState();
  }

  getResidents() async {
    refResident = fb.ref().child('residents');
    refResident.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      printOnlyInDebug(data);
    });
    // final snapshot = await refResident.get();
    // if (snapshot.exists) {
    //   print(snapshot.value);
    // } else {
    //   print('No data available.');
    // }
  }

  @override
  Widget build(BuildContext context) {
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

        pickedTime.value = result.toIso8601String();
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
              hintText: "Residents",
              controller: resident,
              onTap: () {
                showModalSheet(
                    context: context,
                    child: FirebaseAnimatedList(
                        query: refResident,
                        shrinkWrap: true,
                        defaultChild: const Center(
                          child: Text(
                            "No residents added yet",
                            style: TextStyle(
                                color: green,
                                fontWeight: FontWeight.w700,
                                fontSize: 24),
                          ),
                        ),
                        itemBuilder: (context, snapshot, animation, index) {
                          if (snapshot.exists) {
                            var data = json.encode(snapshot.value);
                            res = json.decode(data);
                            
                            //printOnlyInDebug(res["name"]);
                            // var todo = todoFromJson(data);

                            return data.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      resident.text =
                                          pickedResident.value = res["name"];
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            tileColor: const Color.fromARGB(
                                                249, 247, 248, 248),
                                            title: Text(
                                              res["name"],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            subtitle: Text(
                                              res["special_need"],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      "No residents added yet",
                                      style: TextStyle(
                                          color: green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ),
                                  );
                          } else {
                            return const Center(
                              child: Text(
                                "No residents added yet",
                                style: TextStyle(
                                    color: green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              ),
                            );
                          }
                        }),
                    //["Female", "Male", "Prefer not to say"],
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
                      "residentId": res['residentId'],
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
