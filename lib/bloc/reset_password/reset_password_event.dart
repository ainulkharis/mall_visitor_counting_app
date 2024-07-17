abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordSubmitted({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class ValidateToken extends ResetPasswordEvent {
  final String token;

  ValidateToken({required this.token});
}
