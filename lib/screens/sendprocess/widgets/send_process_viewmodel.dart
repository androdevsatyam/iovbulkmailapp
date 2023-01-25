import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import '../../../widgets/SnackBarWidget.dart';
import '../../mysaved_data.dart';

class SendProcessViewModel extends BaseViewModel {
  TextEditingController emailId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController receipientId = TextEditingController();
  TextEditingController sendMessage = TextEditingController();

  FocusNode emailIdFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode receipientIdFocus = FocusNode();
  FocusNode sendMessageFocus = FocusNode();

  String emailIdError = '';
  String passwordError = '';
  String receipientIdError = '';
  String sendMessageError = '';

  String message = '';
  List<SendData> bulkDetails = [];

  bool startSend = false, login = false;

  void onSubmit() {
    if (validateData()) {
      print("validate true");
      List<String> destIds = receipientId.text.split(",");
      message = sendMessage.text;
      for (var id in destIds) {
        bulkDetails.add(SendData(id.toString(), message));
      }
      print("bulk data=" + bulkDetails.length.toString());
      MySavedData savedData =
          MySavedData(SigninData(emailId.text, password.text), bulkDetails);
      Get.put(savedData);
      startSend = true;
      print("Start Send=$startSend");
    }
    notifyListeners();
  }

  void onLogin() {
    if (checkId()) {
      SigninData signinData = SigninData(emailId.text, password.text);
      Get.lazyPut(() => signinData);
      login = true;
      notifyListeners();
    }
  }

  void sendData() {
    if (checkId()) {
      SigninData signinData = SigninData(emailId.text, password.text);
      Get.put(signinData);
      login = true;
      notifyListeners();
    }
  }

  bool checkId() {
    bool result = true;
    if (emailId.text == '' || !GetUtils.isEmail(emailId.text)) {
      emailIdFocus.requestFocus();
      emailIdError = "Input valid Email";
      SnackBarWidget().snackBarWidget("Input valid Email");
      result = false;
    } else if (password.text == '') {
      passwordFocus.requestFocus();
      passwordError = "Input valid password";
      SnackBarWidget().snackBarWidget("Input valid password");
      result = false;
    } else {
      result = true;
    }
    return result;
  }

  bool validateData() {
    bool result = true;
    if (sendMessage.text == '') {
      sendMessageFocus.requestFocus();
      sendMessageError = "Empty Message Can not be sent";
      SnackBarWidget().snackBarWidget("Empty Message Can not be sent");
      result = false;
    } else if (receipientId.text == '') {
      receipientIdFocus.requestFocus();
      receipientIdError = "Add Destinations seperated by (,)";
      SnackBarWidget().snackBarWidget("Add Destination seperated by (,)");
      result = false;
    } else {
      result = true;
    }
    notifyListeners();
    return result;
  }
}
