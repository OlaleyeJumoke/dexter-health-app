import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddResident extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
