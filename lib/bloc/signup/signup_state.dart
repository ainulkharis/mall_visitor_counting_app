import 'package:flutter/material.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupLoaded extends SignupState {
  final dynamic model;
  SignupLoaded({required this.model});
}

class SignupError extends SignupState {
  final String error;
  SignupError({required this.error});
}
