import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/login/login_bloc.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:mall_visitor_counting/data/models/requests/login_request_model.dart';
import 'home_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong!';
    }
    if (!value.contains('@')) {
      return 'Format email tidak valid!';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong!';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter!';
    }
    return null;
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(AuthDatasource()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoaded) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text('Login Berhasil',
                        style: TextStyle(color: Colors.black)),
                    content: Text('Selamat datang Anda berhasil login.',
                        style: TextStyle(color: Colors.black)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text('OK',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  );
                },
              );
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login gagal! ${state.message}'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 90.0),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          cursorColor: Colors.cyan,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            floatingLabelStyle:
                                TextStyle(color: Colors.cyan),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.cyan, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          validator: _validatePassword,
                          cursorColor: Colors.cyan,
                          decoration: InputDecoration(
                            labelText: 'Kata sandi',
                            floatingLabelStyle:
                                TextStyle(color: Colors.cyan),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.cyan, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _navigateToForgotPassword(context);
                            },
                            child: Text(
                              'Lupa kata sandi?',
                              style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        state is LoginLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.cyan)))
                            : ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final loginModel = LoginRequestModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    context.read<LoginBloc>().add(
                                          DoLoginEvent(loginModel: loginModel),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Formulir tidak valid!'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  backgroundColor: Colors.cyan,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                        SizedBox(height: 30.0),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum memiliki akun? ",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _navigateToSignUp(context),
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
