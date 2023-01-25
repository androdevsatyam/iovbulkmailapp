import 'package:bulkmail/screens/sendprocess/widgets/send_process_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/fontres.dart';

class LoginDetails extends StatelessWidget {
  final SendProcessViewModel model;
  const LoginDetails({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, top: 10, right: 20),
        width: Get.width / 3,
        child: Column(
          children: <Widget>[
            Text(
              "Authenticate First",
              style: TextStyle(
                  fontSize: 20,
                  wordSpacing: 6,
                  letterSpacing: 2,
                  fontFamily: FontRes.semiBold),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: model.emailId,
              focusNode: model.emailIdFocus,
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 19,
              ),
              keyboardType: TextInputType.emailAddress,
              decoration: getDecoration(
                  model.emailIdError, 'Enter Host Email'),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: model.password,
              focusNode: model.passwordFocus,
              obscureText: true,
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 19,
              ),
              keyboardType: TextInputType.text,
              decoration: getDecoration(
                  model.passwordError, 'Enter Host Password'),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: model.onLogin,
              child: Text("Log In"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 30,
                          right: 30)),
                  textStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 19))),
            )
          ],
        ));
  }

  getDecoration(String errorcheck, String errorplace) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 14),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.indigoAccent)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 3)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 3)),
      hintText: errorcheck == "" ? errorplace : errorcheck,
      hintStyle: TextStyle(
        color: errorcheck == "" ? Colors.black54 : Colors.red,
        fontSize: 14,
      ),
    );
    // return errorcheck==''?
    //   InputDecoration(
    //   contentPadding: const EdgeInsets.only(left: 14),
    //   enabledBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.indigoAccent)),
    //   focusedBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 3)),
    //   errorBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.red, width: 3)),
    //   hintText: errorcheck == "" ? errorplace : errorcheck,
    //   hintStyle: TextStyle(
    //     color: errorcheck == "" ? Colors.black54 : Colors.red,
    //     fontSize: 14,
    //   ),
    // ):
    // InputDecoration(
    //   contentPadding: const EdgeInsets.only(left: 14),
    //   enabledBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.indigoAccent)),
    //   focusedBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 3)),
    //   errorBorder: OutlineInputBorder(
    //       borderSide: BorderSide(color: Colors.red, width: 3)),
    //   hintText: errorcheck == "" ? errorplace : errorcheck,
    //   errorText: errorcheck,
    //   hintStyle: TextStyle(
    //     color:Colors.black54 ,
    //     fontSize: 14,
    //   ),
    // );
  }

}
