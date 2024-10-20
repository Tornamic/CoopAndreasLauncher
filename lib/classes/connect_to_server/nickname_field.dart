import 'package:flutter/material.dart';

class NickNameField {

  NickNameField(void Function() function) {
    getNickNameFocusNode.addListener(function);
  }

  bool _isNickNameValid = false;
  bool _isNickNameFieldFocusing = false;

  final RegExp _nickNameRegExp = RegExp(r"^([a-zA-Z0-9_\[\]]{3,24})$");
  final FocusNode _nickNameFocusNode = FocusNode();

  get isNickNameValid => _isNickNameValid;
  get isNickNameFieldFocusing => _isNickNameFieldFocusing;

  bool isNickNameValidEx(bool isPressedConnect) {

    if(!_isNickNameFieldFocusing && isPressedConnect && !isNickNameValid) {
      return false;
    }

    return !(_isNickNameFieldFocusing && !isNickNameValid);
  }

  get getNickNameRegExp => _nickNameRegExp;
  get getNickNameFocusNode => _nickNameFocusNode;

  void toggleNickNameValid(bool isNickNameValid) {
    _isNickNameValid = isNickNameValid;
  }

  void toggleNickNameFocusing(bool isNickNameFieldFocusing) {
    _isNickNameFieldFocusing = isNickNameFieldFocusing;
  }
}