part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class EditProfileEvent extends ProfileEvent {
  final File? avatar;
  final String name;
  final String email;

  EditProfileEvent({
    this.avatar,
    required this.name,
    required this.email,
  });
}
