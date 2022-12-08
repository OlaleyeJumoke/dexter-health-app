import 'dart:convert';

import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/add_resident.dart';
import 'package:dexter_health/views/add_todo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String id = 'home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  var ref;
  @override
  void initState() {
    ref = fb.ref().child('todos');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(width: 0,height: 0,),
          centerTitle: true,
          title: const Text(
            "Todo List",
            style: TextStyle(
                color: white, fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
          actions: [GestureDetector(child:const Padding(
            padding:  EdgeInsets.all(8.0),
            child: Icon(Icons.save),
          ) , onTap: ()=>Navigator.pushNamed(context, AddResident.id),)],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add todo",
          onPressed: (() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTodo()));
          }),
          child: const Icon(Icons.add),
        ),
        body: FirebaseAnimatedList(
            query: ref,
            shrinkWrap: true,
            defaultChild: const Center(
              child: Text(
                "No todo added/available yet",
                style: TextStyle(
                    color: green, fontWeight: FontWeight.w700, fontSize: 24),
              ),
            ),
            itemBuilder: (context, snapshot, animation, index) {
              if (snapshot.exists) {
                var data = json.encode(snapshot.value);
                var todo = todoFromJson(data);

                return data.isNotEmpty
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Color.fromARGB(250, 235, 244, 242),
                                trailing: Checkbox(
                                    value: todo.completed,
                                    onChanged: (value) {
                                      printOnlyInDebug(value);
                                      ref
                                          .child(snapshot.key!)
                                          .update({"completed": value});
                                    }),
                                title: Text(
                                  todo.todo,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat("hh:mm a")
                                      .format(
                                          DateTime.parse(todo.timeToExecute))
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No todo added/available yet",
                          style: TextStyle(
                              color: green,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      );
              } else {
                return const Center(
                  child: Text(
                    "No todo added/available yet",
                    style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                );
              }
            }));
  }
}
