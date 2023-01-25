import 'package:bulkmail/screens/login_details.dart';
import 'package:bulkmail/screens/submit_data.dart';
import 'package:bulkmail/screens/sending_mails/sendmails.dart';
import 'package:bulkmail/screens/sendprocess/widgets/send_process_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:stacked/stacked.dart';
import '../../centeredview/centered_view.dart';
import '../../widgets/SnackBarWidget.dart';
import '../../widgets/navigation_bar.dart';
import '../mysaved_data.dart';

class SendProcess extends StatelessWidget {
  const SendProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print("object");
    return ViewModelBuilder<SendProcessViewModel>.reactive(
      onViewModelReady: (model) {
        model.emailId.text = 'satyamiovrvf@gmail.com';
        model.password.text = '2023IOVsatyam';
        model.receipientId.text =
            'iovayush47@gmail.com,satyam8690771@gmail.com,fervidmail@gmail.com,fervidbuddy@gmail.com';
        model.sendMessage.text = 'this is test';
      },
      viewModelBuilder: () => SendProcessViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(children: <Widget>[
            CenteredView(child: NavigationView()),
            LoginDetails(model: model),
            SubmitData(model: model),
            SizedBox(
              height: 20,
            ),
            model.startSend
                ? ElevatedButton(
                    onPressed: () async {
                      prepare();
                    },
                    child: Text("Start Sending.."),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.only(
                            top: 20, bottom: 20, left: 30, right: 30)),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 19))),
                  )
                : SizedBox(
                    height: 1,
                  )
          ]),
        );
      },
    );
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

  Future<void> prepare() async {
    List<SendReport> sendreport = [];
    List<Message> emailQueue = [];

    SigninData signinData = Get.find();
    MySavedData savedData = Get.find();
    print("signdata=$signinData");
    print("Saved=$savedData");
    SmtpServer server = gmail(signinData.user_id!, signinData.user_pass!);
    // Add emails to the queue
    List<SendData> list = savedData.list!;

    for (var element in list) {
      Message msg = Message()
        ..from = Address(signinData.user_id!, 'IOV')
        ..recipients.add(element.mailid!)
        ..ccRecipients.addAll(['satyamiovrvf@gmail.com'])
        ..bccRecipients.add(const Address('iovayush47@gmail.com'))
        ..subject = 'Testing Mail :: 😀 :: ${DateTime.now()}'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<h1>Test</h1>\n<p>Hey! Here's your message that you inserted $element.message!</p>";
      emailQueue.add(msg);

    }

    print("emailqueue=$emailQueue =>" + emailQueue.length.toString());

    var connection = PersistentConnection(server);
    for(var email in emailQueue){
      SendReport report = await connection.send(email);
      sendreport.add(report);
    }
    await connection.close();

    for (var element in sendreport) {
      SnackBarWidget.snackBar(message: "Send report $element");
    }
  }

}
