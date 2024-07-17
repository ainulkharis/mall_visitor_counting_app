import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/change_password/change_password_bloc.dart';
import 'package:mall_visitor_counting/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mall_visitor_counting/bloc/login/login_bloc.dart';
import 'package:mall_visitor_counting/bloc/profile/profile_bloc.dart';
import 'package:mall_visitor_counting/bloc/signup/signup_bloc.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:mall_visitor_counting/pages/history_page.dart';
import 'package:mall_visitor_counting/pages/profile_page.dart';
import 'package:mall_visitor_counting/pages/welcome_page.dart';
import 'package:mall_visitor_counting/pages/login_page.dart';
import 'package:mall_visitor_counting/pages/signup_page.dart';
import 'package:mall_visitor_counting/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:mall_visitor_counting/data/localsources/auth_local_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthLocalStorage>(
          create: (_) => AuthLocalStorage(),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(AuthDatasource()),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(AuthDatasource()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => ChangePasswordBloc(AuthDatasource()),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordBloc(AuthDatasource()),
        ),
      ],
      child: MaterialApp(
        title: 'Mall Visitor Counting App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/signup': (context) => SignupPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/history': (context) => HistoryPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
