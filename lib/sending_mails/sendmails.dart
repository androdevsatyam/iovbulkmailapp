import 'dart:collection';
import 'package:get/get.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';

import '../../models/MySavedData.dart';
import '../../models/SigninData.dart';
import '../../widgets/SnackBarWidget.dart';

class SendMails {

  Future<void> prepare() async {
    List<SendReport> sendreport = [];
    List<Message> emailQueue = [];
    SmtpServer server = gmail("fervidbuddy@gmail.com", "fervidbuddy2023");

    print("host=${server.host}");
    Message msg = Message()
      ..from = Address('fervidbuddy@gmail.com', 'IOV')
      ..recipients.add("satyamiorvf@gmail.com")
      ..subject = 'Testing Mail'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's your message that you inserted</p>";
    emailQueue.add(msg);
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
