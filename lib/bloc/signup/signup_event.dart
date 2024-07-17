import 'package:mall_visitor_counting/data/models/requests/signup_request_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SignupEvent {}

class SaveSignupEvent extends SignupEvent {
  final SignupRequestModel request;

  SaveSignupEvent({required this.request});
}
