import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/signup/signup_bloc.dart';
import 'package:mall_visitor_counting/bloc/signup/signup_event.dart';
import 'package:mall_visitor_counting/bloc/signup/signup_state.dart';
import 'package:mall_visitor_counting/data/models/requests/signup_request_model.dart';
import 'package:mall_visitor_counting/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  String? _emailError;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong!';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong!';
    }
    if (!value.contains('@')) {
      return 'Format email tidak valid!';
    }
    if (_emailError != null) {
      return _emailError;
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

  void _signUp(BuildContext context) {
    setState(() {
      _emailError = null;
      _isLoading = true;
    });

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final requestModel = SignupRequestModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      context.read<SignupBloc>().add(SaveSignupEvent(request: requestModel));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SignupBloc>().stream.listen((state) {
      if (state is SignupLoaded) {
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Sign up Berhasil',
                  style: TextStyle(color: Colors.black)),
              content: Text(
                  'Silakan cek email Anda untuk mengkonfirmasi akun!',
                  style: TextStyle(color: Colors.black)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('OK', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      } else if (state is SignupError) {
        setState(() {
          _isLoading = false;
          if (state.error == 'Email sudah digunakan!') {
            _emailError = 'Email sudah digunakan!';
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal mendaftarkan akun pengguna!'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          _formKey.currentState!.validate();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80.0),
                TextFormField(
                  controller: _nameController,
                  validator: _validateName,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    floatingLabelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.cyan, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.cyan, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  controller: _passwordController,
                  validator: _validatePassword,
                  obscureText: _obscureText,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi',
                    floatingLabelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.cyan, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.cyan)))
                    : ElevatedButton(
                        onPressed: () => _signUp(context),
                        child: Text('Sign up'),
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
                        'Sudah memiliki akun? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
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
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
