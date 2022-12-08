import 'package:dexter_health/constant.dart';
import 'package:flutter/material.dart';

class CustomTextFieldDropDown extends StatelessWidget {
  const CustomTextFieldDropDown({
    Key? key,
    required this.hintText,
    this.controller,
    this.width = 343,
    this.suffixIcon,
    required this.onTap,
    this.onChanged,
  }) : super(key: key);
  final String hintText;

  final TextEditingController? controller;
  final double width;
  final Widget? suffixIcon;
  final Function() onTap;
  final Function(String)? onChanged;

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        Center(
          child: SizedBox(
            width: width,
            child: TextFormField(
              onTap: onTap,
              controller: controller,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: "",
                  fontWeight: FontWeight.w400),
              cursorHeight: 20,
              cursorColor: green,
              showCursor: false,
              readOnly: true,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  fillColor: Color.fromARGB(251, 243, 247, 246),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: green)),
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: const Color(0xFFB7B7B9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  suffixIcon: const Icon(Icons.arrow_drop_down)),
              onChanged: onChanged,
              onSaved: (newValue) {},
              validator: (value) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showModalSheet(
    {required BuildContext context,
     List<dynamic>? items,
    Widget? child,
    required String? Function(dynamic)? callBack}) {
  return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      //isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: child ?? ListView.builder(
                  itemCount: items!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          callBack!(items[index]);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            const Divider(),
                            Container(
                                child: ListTile(
                                    title: Text(
                              items[index],
                            ))),
                          ],
                        ));
                  }),
        );
      });
}
