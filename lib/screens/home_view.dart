import 'package:flutter/material.dart';

import 'click_view.dart';
import 'course_details.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IOV Mailing"),
      ),
        backgroundColor: Colors.white24,
        body:Column(children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                CourseDetails(),
                Expanded(
                    child: Center(child: ClickDetails("Press to Continue")))
              ],
            ))
          ]),
        );
  }
}
