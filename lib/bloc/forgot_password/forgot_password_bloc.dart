import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthDatasource authDatasource;

  ForgotPasswordBloc(this.authDatasource) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await authDatasource.forgotPassword(event.email);
      emit(ForgotPasswordSuccess(response.message));
    } catch (error) {
      emit(ForgotPasswordFailure(error.toString()));
    }
  }
}
