import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/change_password/change_password_bloc.dart';
import 'package:mall_visitor_counting/data/models/requests/password_request_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController? currentPasswordController;
  TextEditingController? newPasswordController;

  bool _isCurrentPasswordObscured = true;
  bool _isNewPasswordObscured = true;

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordObscured = !_isCurrentPasswordObscured;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordObscured = !_isNewPasswordObscured;
    });
  }

  @override
  void initState() {
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordController?.dispose();
    newPasswordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah kata sandi'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            currentPasswordController!.clear();
            newPasswordController!.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kata sandi berhasil diubah.')),
            );
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Gagal mengubah kata sandi: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: currentPasswordController,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi saat ini',
                    floatingLabelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.cyan)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isCurrentPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleCurrentPasswordVisibility,
                    ),
                  ),
                  obscureText: _isCurrentPasswordObscured,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  cursorColor: Colors.cyan,
                  decoration: InputDecoration(
                    labelText: 'Kata sandi baru',
                    floatingLabelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.cyan)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: _toggleNewPasswordVisibility,
                    ),
                  ),
                  obscureText: _isNewPasswordObscured,
                ),
                SizedBox(height: 25),
                BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                  builder: (context, state) {
                    if (state is ChangePasswordLoading) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final requestModel = PasswordRequestModel(
                          currentPassword: currentPasswordController!.text,
                          newPassword: newPasswordController!.text,
                        );
                        context.read<ChangePasswordBloc>().add(
                              ChangePassword(passwordModel: requestModel),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 149, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Simpan',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
