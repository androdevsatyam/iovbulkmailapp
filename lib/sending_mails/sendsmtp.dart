import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../widgets/SnackBarWidget.dart';

class SendSmtp {
  // String username = 'satyamiovrvf@gmail.com';
  // String password = 'zzqwblnarqpblfel'; // 2 Step password
  // String password = '2023IOVsatyam';

  String emailId = 'satyam@iovrvf.org';
  String emailPass = 'Satyam19sep!@';

  // String receipt='';
  List<String> receipt=[];
  String body ='';
  List<Message> emailQueue = [];
  List<SendReport> sendreport = [];

  SendSmtp(List<String> text, String text2){
    print("data receive $text $text2");
    receipt=text;
    body=text2;
  }

  sendmails() async {
    final smtpServer = SmtpServer('iovrvf.org',
        username: emailId, password: emailPass, port: 465, ssl: true);

    receipt.forEach((element) {
      Message msg = Message()
        ..from = Address(emailId, 'Bulk Test')
        ..recipients.add(element)
        ..subject = 'Testing Mail'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = "<h1>Test</h1>\n<p>Hey! Here's your message that you inserted</p>";
      emailQueue.add(msg);
    });

    print("emailqueue=$emailQueue =>" + emailQueue.length.toString());

    var connection = PersistentConnection(smtpServer);

    for(var email in emailQueue){
      try {
        send(email, smtpServer).then((value) => {
          sendreport.add(value),
          SnackBarWidget.snackBar(message: "Mail hits your inbox"),
          print('Message sent: ' + value.toString())
        });
        // await connection.send(email).then((value) => {
        //   sendreport.add(value)
        // });
      } on MailerException catch (e) {
        print('Message not sent. $e');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
    await connection.close();

   /* final message = Message()
      ..from = Address(emailId, 'Hello')
      ..recipients.add(receipt)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test:: 😀 :: ${DateTime.now()}'
      ..html = "<h1>$body</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      send(message, smtpServer).then((value) => {
        sendreport.add(value),
            SnackBarWidget.snackBar(message: "Mail hits your inbox"),
            print('Message sent: ' + value.toString())
          });
    } on MailerException catch (e) {
      print('Message not sent. $e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }*/
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
