import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mall_visitor_counting/data/models/requests/password_request_model.dart';
import '../../data/datasources/auth_datasources.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthDatasource authDatasource;

  ChangePasswordBloc(this.authDatasource) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) async {
      if (event is ChangePassword) {
        emit(ChangePasswordLoading());
        try {
          await authDatasource.changePassword(event.passwordModel);
          emit(ChangePasswordSuccess());
        } catch (e) {
          emit(ChangePasswordFailure(e.toString()));
        }
      }
    });
  }
}
