part of 'login_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final bool status;
  final bool loading;
  final String error;

  LoginState({
    this.email = '',
    this.password = '',
    this.status = false,
    this.loading = false,
    this.error = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? status,
    bool? loading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
