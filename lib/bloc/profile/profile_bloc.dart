import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mall_visitor_counting/data/datasources/auth_datasources.dart';
import 'package:mall_visitor_counting/data/models/response/profile_response_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthDatasource authDatasource;

  ProfileBloc(this.authDatasource) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfileEvent);
    on<EditProfileEvent>(_onEditProfileEvent);
  }

  Future<void> _onGetProfileEvent(GetProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final result = await authDatasource.getProfile();
      emit(ProfileLoaded(profile: result));
    } catch (e) {
      emit(ProfileError(message: 'Masalah jaringan: ${e.toString()}'));
    }
  }

  Future<void> _onEditProfileEvent(EditProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final result = await authDatasource.editProfile(
        avatar: event.avatar,
        name: event.name,
        email: event.email,
      );

      if (result.emailRequiresConfirmation) {
        emit(ProfileUpdated(
            message: 'Silakan periksa email baru Anda untuk mengkonfirmasi!'));
      } else {
        emit(ProfileUpdated(
            message: result.message ?? 'Profil berhasil diperbarui.'));
      }
    } catch (e) {
      emit(ProfileError(message: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
