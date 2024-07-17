import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall_visitor_counting/bloc/profile/profile_bloc.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  String? nameError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<bool> _checkImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void validateInputs() {
    setState(() {
      nameError = _nameController!.text.isEmpty ? 'Nama tidak boleh kosong!' : null;
      emailError =
          _emailController!.text.isEmpty ? 'Email tidak boleh kosong!' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            print("Profil diperbarui: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            if (state.message ==
                'Silakan periksa email baru Anda untuk mengkonfirmasi perubahan email!') {
              Navigator.of(context).pop();
            }
            context.read<ProfileBloc>().add(GetProfileEvent());
          } else if (state is ProfileError) {
            print("Kesalahan profil: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<ProfileBloc>().add(GetProfileEvent());
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              _nameController!.text = state.profile.name ?? '';
              _emailController!.text = state.profile.email ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.orange],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                            ),
                            child: _image != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(_image!),
                                  )
                                : FutureBuilder<bool>(
                                    future: _checkImageUrl(
                                        state.profile.avatar ?? ''),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData &&
                                            snapshot.data == true) {
                                          return CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                                state.profile.avatar!),
                                          );
                                        } else {
                                          return CircleAvatar(
                                            radius: 60,
                                            backgroundImage: AssetImage(
                                                'assets/images/default-profile.jpg'),
                                          );
                                        }
                                      } else {
                                        return CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey,
                                        );
                                      }
                                    },
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.add_a_photo,
                                  size: 20, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      cursorColor: Colors.cyan,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                        errorText: nameError,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
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
                        errorText: emailError,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        validateInputs();
                        if (nameError == null && emailError == null) {
                          context.read<ProfileBloc>().add(EditProfileEvent(
                                avatar: _image,
                                name: _nameController!.text,
                                email: _emailController!.text,
                              ));
                        }
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
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }
}
