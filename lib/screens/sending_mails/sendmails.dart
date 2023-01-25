import 'dart:collection';
import 'package:bulkmail/widgets/SnackBarWidget.dart';
import 'package:get/get.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';

import '../mysaved_data.dart';

class SendMails {
  // List<Message> emailQueue = [];
  // late SmtpServer server;
  // late SigninData signinData;
  // late MySavedData savedData;
  // List<SendReport> sendreport = [];

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

class MailMessage {
  String from = '', to = '', subject = '', body = '';

  MailMessage(
      {required this.from,
      required this.to,
      required this.subject,
      required this.body});
}
