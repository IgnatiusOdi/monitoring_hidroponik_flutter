import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/authentication_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository}) : super(LoginInitial()) {
    on<EmailChangedEvent>(onEmailChangedEvent);
    on<PasswordChangedEvent>(onPasswordChangedEvent);
    on<LoginEmailPassword>(onLoginEmailPassword);
    on<SignOut>(onSignOut);
  }

  void onEmailChangedEvent(event, emit) {
    emit(LoginChanged(
        event.email, state.password, state.status, state.loading, ''));
  }

  void onPasswordChangedEvent(event, emit) {
    emit(LoginChanged(
        state.email, event.password, state.status, state.loading, ''));
  }

  void onLoginEmailPassword(event, emit) async {
    emit(LoginChanged(state.email, state.password, state.status, true, ''));

    if (state.email.isEmpty || state.password.isEmpty) {
      emit(LoginChanged(state.email, state.password, state.status, false,
          'Email / Password kosong!'));
      return;
    }

    try {
      await authenticationRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(LoginChanged(state.email, state.password, true, false, ''));
    } catch (_) {
      emit(LoginChanged(state.email, state.password, state.status, false,
          'Email / Password salah!'));
    }
  }

  void onSignOut(event, emit) async {
    await authenticationRepository.signOut();
    emit(LoginInitial());
  }
}
