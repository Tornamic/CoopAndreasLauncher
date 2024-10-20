import 'package:flutter/material.dart';

class IpPortField {

  IpPortField(void Function() function) {
    _ipPortFocusNode.addListener(function);
  }

  bool _isIpPortValid = false;
  bool _isIpPortFieldFocusing = false;

  final RegExp _ipPortRegExp = RegExp(r"\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?):\d{1,5}\b");
  final FocusNode _ipPortFocusNode = FocusNode();

  get isIpPortValid => _isIpPortValid;
  get isIpPortFieldFocusing => _isIpPortFieldFocusing;

  get getIpPortRegExp => _ipPortRegExp;
  get getIpPortFocusNode => _ipPortFocusNode;

  bool isIpPortValidEx(bool isPressedConnect) {

    if(!_isIpPortFieldFocusing && isPressedConnect && !_isIpPortValid) {
      return false;
    }

    return !(_isIpPortFieldFocusing && !_isIpPortValid);
  }

  void toggleIpPortValid(bool isIpPortValid) => _isIpPortValid = isIpPortValid;
  void toggleIpPortFocusing(bool isIpPortFieldFocusing) => _isIpPortFieldFocusing = isIpPortFieldFocusing;
}