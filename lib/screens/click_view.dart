import 'package:bulkmail/screens/sendprocess/send_process.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClickDetails extends StatelessWidget {
  String title;
  ClickDetails(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child:
      InkWell(
        onTap: () {
          Get.to(() =>SendProcess());
        },
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.blue.shade800, borderRadius: BorderRadius.circular(10)),
    );
  }
}
