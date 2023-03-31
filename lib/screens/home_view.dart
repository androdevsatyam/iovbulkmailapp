import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iovbulkmailapp/screens/viewmodel/home_view_model.dart';
import 'package:iovbulkmailapp/widgets/SnackBarWidget.dart';
import 'package:stacked/stacked.dart';

import '../sending_mails/sendsmtp.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) {
        model.mailSubject.text = "Happy Birthday";
        model.mailPerson.text = "IOV Wishes";

        model.subjectFocusNode.addListener(model.onSubjectFocusChange);
      },
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, chile) {
        return Scaffold(
            appBar: AppBar(title: Text("Send Mails")),
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("Send Email in Bulk", style: TextStyle(fontSize: 25)),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54, width: 1.5)),
                            child: Column(
                              children: [
                                Text("Mail Setup",
                                    style: TextStyle(fontSize: 25)),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  controller: model.mailPerson,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.indigoAccent,
                                              width: 1)),
                                      hintText: "Mail Type"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  focusNode: model.subjectFocusNode,
                                  controller: model.mailSubject,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.indigoAccent,
                                              width: 1)),
                                      hintText: "Subject"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
                            child: Column(
                              children: [
                                Text("Fill the Form",
                                    style: TextStyle(fontSize: 25)),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  controller: model.receipientController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: "Person's Email-Id",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.indigoAccent,
                                              width: 1)),
                                      hintText: "Receipient Address"),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                if (model.wishes) ...{
                                  TextField(
                                    controller: model.messageController,
                                    decoration: InputDecoration(
                                        labelText: "Person Name",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.indigoAccent,
                                                width: 1)),
                                        hintText: "Birthday Name"),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    controller: model.ivcIDController,
                                    decoration: InputDecoration(
                                        labelText: "Registration ID",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.indigoAccent,
                                                width: 1)),
                                        hintText: "Registration ID"),
                                  )
                                } else
                                  TextField(
                                    controller: model.msgBodyController,
                                    decoration: InputDecoration(
                                        labelText: "Message Body",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.indigoAccent,
                                                width: 1)),
                                        hintText: "Your Mail Text"),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        List<String> emails = model
                                            .receipientController.text
                                            .trim()
                                            .replaceAll(" ", "")
                                            .split(",");
                                        List<String> names = model
                                            .messageController.text
                                            .trim()
                                            .split(",");

                                        List<String> ivcID =
                                            model.ivcIDController.text.isEmpty
                                                ? []
                                                : model.ivcIDController.text
                                                    .trim()
                                                    .replaceAll(" ", "")
                                                    .toUpperCase()
                                                    .split(",");
                                        if (emails.length == names.length) {
                                          if (model.wishes) {
                                            if (names.length == ivcID.length) {
                                              SendSmtp mails = SendSmtp(
                                                  emails,
                                                  names,
                                                  ivcID,
                                                  model.mailPerson.text,
                                                  model.mailSubject.text);
                                              await mails.sendmails();
                                            } else {
                                              SnackBarWidget.snackBar(
                                                  message:
                                                      "Provide All users IVC IDs");
                                            }
                                          } else {
                                            if (model.msgBodyController.text
                                                .isNotEmpty) {
                                              SendSmtp mails = SendSmtp.info(
                                                  emails,
                                                  names,
                                                  model.msgBodyController.text
                                                      .toString(),
                                                  model.mailPerson.text,
                                                  model.mailSubject.text);
                                              try {
                                                await mails.sendmails();
                                              }catch(e){
                                                print(e);
                                              }
                                            } else {
                                              SnackBarWidget.snackBar(
                                                  message:
                                                      "Mail Body Can't be Empty");
                                            }
                                          }
                                        } else
                                          SnackBarWidget.snackBar(
                                              message:
                                                  "mails and names are mismatch in count");
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Text(
                                          "Send Mail",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
