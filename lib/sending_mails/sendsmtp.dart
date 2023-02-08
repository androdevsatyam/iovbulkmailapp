import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../widgets/SnackBarWidget.dart';
import '../widgets/const_res.dart';

class SendSmtp {
  // String username = 'satyamiovrvf@gmail.com';
  // String password = 'zzqwblnarqpblfel'; // 2 Step password
  // String password = '2023IOVsatyam';

  // String emailId = 'satyam@iovrvf.org';
  // String emailPass = 'Satyam19sep!@';

  String emailId = 'no-reply@iovrvf.net';
  String emailPass = 'iK;@e1%(a8{G';

  // String receipt='';
  List<String> receipt = [];
  List<String> names = [];
  List<String> ivcID = [];
  String body = 'empty body', mailtype = 'INFO', subject = '';
  List<Message> emailQueue = [];
  List<SendReport> sendreport = [];

  SendSmtp(List<String> emails, List<String> names,List<String> ivcID, String mailtype,
      String subject) {
    print("data receive $emails $names");
    receipt = emails;
    this.names = names;
    this.ivcID = ivcID;
    this.mailtype = mailtype;
    this.subject = subject;
  }

  sendmails() async {
    final smtpServer = SmtpServer('iovrvf.org',
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
          ..recipients.add(element)
          ..subject = subject
          ..html = genericUrl(
              ConstRes.html,
              Uri.encodeComponent(names[receipt.indexOf(element)]),
              Uri.encodeComponent(ivcID[receipt.indexOf(element)]));
        // ConstRes.html.replaceAll("{{name}}", Uri.encodeComponent(names[receipt.indexOf(element)]));
      } else {
        msg = Message()
          ..from = Address(emailId, mailtype)
          ..recipients.add(element)
          ..subject = subject
          ..text = body;
      }
      emailQueue.add(msg);
    });

    print("emailqueue=$emailQueue =>" + emailQueue.length.toString());

    var connection = PersistentConnection(smtpServer);

    for (var email in emailQueue) {
      try {
        await connection.send(email).then((value) => {
              SnackBarWidget.snackBar(message: "Mail hits your inbox"),
              sendreport.add(value)
            });
      } on MailerException catch (e) {
        print('Message not sent. $e');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
    await connection.close();
  }

  String genericUrl(String str, String name, String id) {
    str = str.replaceAll('{{name}}', name);
    str = str.replaceAll('{{register_no}}', id);
    return str;
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
