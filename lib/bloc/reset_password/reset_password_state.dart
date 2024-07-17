abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  ResetPasswordFailure(this.error);
}

class TokenValidationSuccess extends ResetPasswordState {
  get token => null;
}

class TokenValidationFailure extends ResetPasswordState {
  final String error;

  TokenValidationFailure(this.error);

  String? get message => null;
}
