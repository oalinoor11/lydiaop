part of 'editprofile_bloc.dart';

@immutable
abstract class EditprofileEvent {}

class UpdateProfileDetailsEvent extends EditprofileEvent {
  final String firtsName;
  final String lastName;
  final String imagePath;
  final String type;

  UpdateProfileDetailsEvent({this.firtsName, this.lastName, this.imagePath,this.type});
}
