import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 30),
      width: 600,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "IOV Institute of Valuers",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40),
            ),
            SizedBox(height: 15),
            Text(
              "The Institution of Valuers is a national valuation body for licensing and regulation of the valuation professionals in India specialized in various disciplines and various kinds of assets. It is under the ownership of Ministry of Corporate Affairs, Government of India. It was founded in 1968 by Shri P. C.",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ]),
    );
  }
}
