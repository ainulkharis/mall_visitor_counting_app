import 'package:bloc/bloc.dart';
import 'package:mall_visitor_counting/bloc/reset_password/reset_password_event.dart';
import 'package:mall_visitor_counting/bloc/reset_password/reset_password_state.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthDatasource authDatasource;

  ResetPasswordBloc(this.authDatasource) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
    on<ValidateToken>(_onValidateToken);
  }

  Future<void> _onValidateToken(
    ValidateToken event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      await authDatasource.validateToken(event.token);
      emit(TokenValidationSuccess());
    } catch (error) {
      emit(TokenValidationFailure('Kesalahan validasi token: $error'));
    }
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      await authDatasource.resetPassword(
          event.token, event.newPassword, event.confirmPassword);
      emit(ResetPasswordSuccess());
    } catch (error) {
      emit(ResetPasswordFailure('Gagal mereset kata sandi: $error'));
    }
  }
}
