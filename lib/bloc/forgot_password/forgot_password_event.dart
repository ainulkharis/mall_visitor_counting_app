abstract class ForgotPasswordEvent {}

class ForgotPasswordRequested extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordRequested(this.email);
}
