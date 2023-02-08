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
        // model.receipientController.text = "pro@iovrvf.org,mep@iovrvf.org,cep@iovrvf.org,arun@iovrvf.org,accounts@iovrvf.org,singhaniavishesh16@gmail.com,monitoring@iovrvf.org";
        // model.messageController.text = "Mr. Pro,Mr. MEP,Mr. CEP,Mr. Arun,Mr. Accounts,Mr Vishesh Singhania,Mr.Monitor";

        // model.receipientController.text = "singhaniavishesh16@gmail.com,satyamiovrvf@gmail.com,fervidmail@gmail.com,fervidbuddy@gmail.com,satyamojha121@gmail.com";
        // model.messageController.text = "Vishesh,Satyam,Fervid,Buddy,Ojha";
        // model.receipientController.text = "satyamiovrvf@gmail.com";
        // model.messageController.text = "satyam";
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
                                border: Border.all(
                                    color: Colors.black54, width: 1.5)),
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
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        List<String> emails = model
                                            .receipientController.text.trim().replaceAll(" ", "")
                                            .split(",");
                                        List<String> names = model
                                            .messageController.text.trim()
                                            .split(",");

                                        List<String> ivcID = model
                                            .ivcIDController.text.trim().replaceAll(" ", "").toUpperCase()
                                            .split(",");

                                        if (emails.length == names.length) {
                                         if(names.length==ivcID.length){
                                           SendSmtp mails = SendSmtp(
                                               emails,
                                               names,
                                               ivcID,
                                               model.mailPerson.text,
                                               model.mailSubject.text);
                                           await mails.sendmails();
                                         }else{
                                           SnackBarWidget.snackBar(
                                               message:
                                               "Provide All users IVC IDs");
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
