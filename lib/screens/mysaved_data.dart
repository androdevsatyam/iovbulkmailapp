class MySavedData {
  SigninData? sign;
  List<SendData>? list;

  MySavedData(sign, list) {
    this.sign = sign;
    this.list = list;
  }

  SigninData? get signData => sign;

  List<SendData>? get getSendData => list;
}

class SigninData {
  String? _user_id;
  String? _user_pass;

  SigninData(user_id, user_pass) {
    _user_id = user_id;
    _user_pass = user_pass;
  }

  String? get user_id => _user_id;

  String? get user_pass => _user_pass;
}

class SendData {
  String? _mailId;
  String? _message;

  SendData(mailId, message) {
    _mailId = mailId;
    _message = message;
  }

  String? get mailid => _mailId;

  String? get message => _message;
}
