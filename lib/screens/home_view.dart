import 'package:flutter/material.dart';
import 'package:iovbulkmailapp/screens/viewmodel/home_view_model.dart';
import 'package:stacked/stacked.dart';

import '../sending_mails/sendsmtp.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (model) {
        model.mailSubject.text="Happy Birthday";
        model.mailPerson.text="birthday";
        model.receipientController.text="satyamiovrvf@gmail.com";
        model.messageController.text="satyam";
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
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.indigoAccent,
                                              width: 1)),
                                      hintText: "Receipient Address"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: model.messageController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.indigoAccent,
                                              width: 1)),
                                      hintText: "Birthday Name"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        SendSmtp mails = SendSmtp(
                                            model.receipientController.text
                                                .split(","),
                                            model.messageController.text,model.mailPerson.text,model.mailSubject.text);
                                        await mails.sendmails();
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
