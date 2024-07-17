import 'package:mall_visitor_counting/bloc/signup/signup_event.dart';
import 'package:mall_visitor_counting/bloc/signup/signup_state.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthDatasource datasource;

  SignupBloc(this.datasource) : super(SignupInitial()) {
    on<SaveSignupEvent>((event, emit) async {
      emit(SignupLoading());
      try {
        final result = await datasource.signup(event.request);
        emit(SignupLoaded(model: result));
      } catch (error) {
        emit(SignupError(error: error.toString()));
      }
    });
  }
}
