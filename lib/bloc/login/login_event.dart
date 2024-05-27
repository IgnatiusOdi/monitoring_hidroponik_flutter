part of 'login_bloc.dart';

sealed class LoginEvent {}

class EmailChangedEvent extends LoginEvent {
  final String email;

  EmailChangedEvent(this.email);
}

class PasswordChangedEvent extends LoginEvent {
  final String password;

  PasswordChangedEvent(this.password);
}

class LoginEmailPassword extends LoginEvent {}

class SignOut extends LoginEvent {}
