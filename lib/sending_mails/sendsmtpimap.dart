import 'dart:convert';
import 'dart:io';
import 'package:enough_mail/enough_mail.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../widgets/SnackBarWidget.dart';
import '../imap/imapparser.dart';
import '../widgets/const_res.dart';

class SendSmtpImap {
  String emailId = 'no-reply@iovrvf.net';
  String emailPass = 'iK;@e1%(a';

  // String emailId = 'satyamiovrvf@gmail.com';
  // String emailPass = 'hodevtglixwkvoba';

  // String receipt='';
  List<String> receipt = [];
  List<String> names = [];
  List<String> ivcID = [];
  String body = 'empty body', mailtype = 'INFO', subject = '';
  List<Message> emailQueue = [];
  List<SendReport> sendreport = [];

  SendSmtpImap(List<String> emails, List<String> names, List<String> ivcID,String mailtype, String subject) {
    print("data receive $emails $names");
    receipt = emails;
    this.names = names;
    this.ivcID = ivcID;
    this.mailtype = mailtype;
    this.subject = subject;
  }

  SendSmtpImap.info(List<String> emails, List<String> names, String body,
      String mailtype, String subject) {
    print("data receive $emails $names");
    receipt = emails;
    this.names = names;
    this.body = body;
    this.mailtype = mailtype;
    this.subject = subject;
  }

  sendmails() async {
    final smtpServer = SmtpServer('iovrvf.net', //'smtp.gmail.com',
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
          // ..bccRecipients.add(Address(emailId))
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
    print("emailqueue=$emailQueue =>" + emailQueue.length.toString());

    final client = ImapClient(isLogEnabled: true);
    await client.connectToServer('mail.iovrvf.net', 993, isSecure: true);

    // final listResponse = await client.sendCommand('LIST "" *',
    //         (imapResponse) => ImapParser.parseFetchResponse(imapResponse));

//     try {
// // Connect to the server and authenticate with your email address and password
//       await client.connectToServer('mail.iovrvf.net', 993, isSecure: true);
//       await client.login(emailId, emailPass);
//
//       // Select the mailbox you want to access
//       final mailboxName = 'Sent Items';
//       final mailboxes = await client.listMailboxes();
//       final mailbox = mailboxes.firstWhere(
//         (m) => m.name == mailboxName,
//       );
//       await client.selectMailbox(mailbox);
//       // Use the mailbox
//       final messages = await client.fetchRecentMessages();
//       print('Messages: $messages');
//     } catch (e) {
//       print('Error selecting mailbox: $e');
//     }
// // Close the connection
//     await client.logout();
    // await client.disconnectFromServer();
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
    final sendReports =
        await Future.wait(messages.map((message) => send(message, smtpServer)));
    return sendReports.toList();
  }

  readMails() async {
    /// Low level IMAP API usage example
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer('mail.iovrvf.net', 993, isSecure: true);
      await client.login(emailId, emailPass);
      final mailboxes = await client.listMailboxes();
      print('mailboxes: $mailboxes');
      await client.selectInbox();

      // fetch 10 most recent messages:
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 1, criteria: 'BODY.PEEK[]');
      for (final message in fetchResult.messages) {
        print(message);
      }
      await client.logout();
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
  }
}
