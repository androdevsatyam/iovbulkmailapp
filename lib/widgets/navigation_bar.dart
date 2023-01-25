import 'package:flutter/material.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
          width: 150,
          height: 80,
          child: Image.asset("assets/logo.png"),
        ),
        Row(
          children: <Widget>[
            const NavBarItem("Profile"),
            SizedBox(width: 60),
            NavBarItem("Contact Us"),
            SizedBox(width: 60),
            NavBarItem("About Us"),
          ],
        )
      ]),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  const NavBarItem(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: Colors.lightBlueAccent),
    );
  }
}
