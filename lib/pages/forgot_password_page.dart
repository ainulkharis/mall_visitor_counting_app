import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mall_visitor_counting/bloc/forgot_password/forgot_password_event.dart';
import 'package:mall_visitor_counting/bloc/forgot_password/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Kata Sandi'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
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
                    borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is ForgotPasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordLoading) {
                    return CircularProgressIndicator();
                  }

                  return ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      context
                          .read<ForgotPasswordBloc>()
                          .add(ForgotPasswordRequested(email));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 159, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Kirim',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
