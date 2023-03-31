import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../widgets/SnackBarWidget.dart';
import '../imap/imapparser.dart';
import '../widgets/const_res.dart';

class SendSmtp {
  String emailId = 'no-reply@iovrvf.net';
  String emailPass = 'iK;@e1%(a';

  List<String> receipt = [];
  List<String> names = [];
  List<String> ivcID = [];
  String body = 'empty body', mailtype = 'INFO', subject = '';
  List<Message> emailQueue = [];
  List<SendReport> sendreport = [];

  SendSmtp(List<String> emails, List<String> names, List<String> ivcID,String mailtype, String subject) {
    print("data receive $emails $names");
    receipt = emails;
    this.names = names;
    this.ivcID = ivcID;
    this.mailtype = mailtype;
    this.subject = subject;
  }

  SendSmtp.info(List<String> emails, List<String> names, String body, String mailtype, String subject) {
    print("data receive $emails $names");
    receipt = emails;
    this.names = names;
    this.body = body;
    this.mailtype = mailtype;
    this.subject = subject;
  }

  sendmails() async {
    // Connect to SMTP server
    final smtpServer = SmtpServer('iovrvf.net',//'smtp.gmail.com',
        username: emailId,
        password: emailPass,
        port: 465,
        ssl: true,
        ignoreBadCertificate: false);

    receipt.forEach((element) {
      Message msg;
      if (subject.toLowerCase().contains("birthday")) {
        msg = Message()
          ..from = Address(emailId, mailtype)
          ..bccRecipients.add(Address(emailId))
          ..recipients.add(element)
          ..subject = subject
          ..html = genericUrl(
              ConstRes.html,
              Uri.encodeComponent(names[receipt.indexOf(element)]),
              Uri.encodeComponent(ivcID[receipt.indexOf(element)]));
      } else {
        msg = Message()
          ..from = Address(emailId, mailtype)
          // ..bccRecipients.add(Address(emailId))
          ..recipients.add(element)
          ..subject = subject
          ..text = body;
      }
      emailQueue.add(msg);
    });


    var connection = PersistentConnection(smtpServer);

    for (var email in emailQueue) {
      try {
        await connection.send(email).then((value) => {
              SnackBarWidget.snackBar(message: "Mail hits your inbox"),
              print('send report=>$value'),
              sendreport.add(value)
            });

      } on MailerException catch (e) {
        print('Message not sent. $e');
        if (e.problems.isNotEmpty) {
          for (var p in e.problems) {
            print('Problem: ${p.code}: ${p.msg}');
          }
        }
        else {
          SnackBarWidget.snackBar(
              message:
                  e.message.toLowerCase().contains("Incorrect authentication")
                      ? 'incorrect authentication'
                      : e.message);
        }
      }
    }

    await connection.close();
  }

  String genericUrl(String str, String name, String id) {
    str = str.replaceAll('{{name}}', name);
    if (id.toLowerCase() == "employee") {
      str = str.replaceAll('{{register_no}}', '');
    } else {
      str = str.replaceAll('{{register_no}}', id);
    }
    return str;
  }

  Future<List<SendReport>> sendMultiple(List<Message> messages, SmtpServer smtpServer) async {
    final sendReports = await Future.wait(messages.map((message) => send(message, smtpServer)));
    return sendReports.toList();
  }

// sendmails() async {
//   final smtpServer = SmtpServer('iovrvf.org',
//       username: emailId, password: emailPass, port: 465, ssl: true);
//   // Use the SmtpServer class to configure an SMTP server:
//   // final smtpServer = SmtpServer('smtp.domain.com');
//   // See the named arguments of SmtpServer for further configuration
//   // options.
//
//   // Create our message.
//   final message = Message()
//     ..from = Address(emailId, 'Hello')
//     ..recipients.add(receipt)
//     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//     // ..bccRecipients.add(Address('bccAddress@example.com'))
//     ..subject = 'Test:: 😀 :: ${DateTime.now()}'
//     ..html = "<h1>$body</h1>\n<p>Hey! Here's some HTML content</p>";
//
//   try {
//     /*final sendReport = await */
//     send(message, smtpServer).then((value) => {
//           SnackBarWidget.snackBar(message: "Mail hits your inbox"),
//           print('Message sent: ' + value.toString())
//         });
//   } on MailerException catch (e) {
//     print('Message not sent. $e');
//     for (var p in e.problems) {
//       print('Problem: ${p.code}: ${p.msg}');
//     }
//   }
// }
}
