import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController receipientController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController ivcIDController = TextEditingController();
  TextEditingController msgBodyController = TextEditingController();
  TextEditingController mailPerson = TextEditingController();
  TextEditingController mailSubject = TextEditingController();

  bool wishes = true;

  FocusNode subjectFocusNode = FocusNode();

  onSubjectFocusChange() {
    if (mailSubject.text.toLowerCase().contains("birthday")) {
      wishes = true;
    } else {
      wishes = false;
    }
    notifyListeners();
  }
}
