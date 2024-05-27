part of 'login_bloc.dart';

sealed class LoginState {
  final String email;
  final String password;
  final bool status;
  final bool loading;
  final String error;

  LoginState(this.email, this.password, this.status, this.loading, this.error);
}

final class LoginInitial extends LoginState {
  LoginInitial() : super('', '', false, false, '');
}

final class LoginChanged extends LoginState {
  LoginChanged(
      super.email, super.password, super.status, super.loading, super.error);
}
