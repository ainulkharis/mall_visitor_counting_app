import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_visitor_counting/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:mall_visitor_counting/bloc/profile/profile_bloc.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:mall_visitor_counting/data/localsources/auth_local_storage.dart';
import 'package:mall_visitor_counting/pages/change_password.dart';
import 'package:mall_visitor_counting/pages/edit_profile_page.dart';
import 'package:mall_visitor_counting/pages/forgot_password_page.dart';
import 'package:mall_visitor_counting/pages/login_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthDatasource authDatasource;

  @override
  void initState() {
    super.initState();
    authDatasource = AuthDatasource();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  Future<bool> _checkImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProfileLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
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
                                child: FutureBuilder<bool>(
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
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfilePage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            state.profile.name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            state.profile.email ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else {
                  return Center(child: Text("Tidak ada data yang tersedia!"));
                }
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height * .50,
                    width: size.width,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileWidget(
                            icon: Icons.person,
                            title: 'Edit Profil',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.lock_outline,
                            title: 'Ubah Kata Sandi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.email_outlined,
                            title: 'Lupa Kata Sandi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) =>
                                        ForgotPasswordBloc(authDatasource),
                                    child: ForgotPasswordPage(),
                                  ),
                                ),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.logout,
                            title: 'Keluar',
                            onTap: () => _logout(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthLocalStorage().clearAuth();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      shadowColor: Colors.cyan,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.cyan,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(icon, color: Colors.cyan),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
