import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:mall_visitor_counting/data/localsources/auth_local_storage.dart';
import 'package:mall_visitor_counting/data/models/requests/login_request_model.dart';
import 'package:mall_visitor_counting/data/models/response/login_response_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDatasource authDatasource;

  LoginBloc(this.authDatasource) : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        final result = await authDatasource.login(event.loginModel);
        print('Login Response: ${result.toJson()}'); // Tambahkan logging response
        await AuthLocalStorage().saveToken(result.accessToken);
        emit(LoginLoaded(loginResponseModel: result));
      } catch (e) {
        print('Login Error: $e'); // Tambahkan logging error
        emit(LoginError(message: "Kata sandi atau email salah!"));
      }
    });
  }
}
