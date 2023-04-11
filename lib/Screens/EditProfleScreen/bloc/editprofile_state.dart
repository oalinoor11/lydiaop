part of 'editprofile_bloc.dart';

@immutable
abstract class EditprofileState {}

class EditprofileInitial extends EditprofileState {}

class EditprofileLoadingState extends EditprofileState {}

class EditprofileLoadedState extends EditprofileState {}

class UploadProfileState extends EditprofileState {
  final StreamedResponse profileResp;
  final bool isNetworkConnected;
  UploadProfileState({this.profileResp, this.isNetworkConnected});
}

class EditprofileErrorState extends EditprofileState {}
