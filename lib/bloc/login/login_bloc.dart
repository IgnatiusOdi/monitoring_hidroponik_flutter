import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/authentication_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc(this.authenticationRepository) : super(LoginState()) {
    on<EmailChangedEvent>((event, emit) {
      try {
        emit(state.copyWith(email: event.email));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<PasswordChangedEvent>((event, emit) {
      try {
        emit(state.copyWith(password: event.password));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<LoginEmailPassword>((event, emit) async {
      try {
        emit(state.copyWith(loading: true, error: ''));

        if (state.email.isEmpty || state.password.isEmpty) {
          emit(state.copyWith(
              loading: false, error: 'Email / Password kosong!'));
          return;
        }

        await authenticationRepository.logInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(
          email: '',
          password: '',
          status: true,
          loading: false,
        ));
      } catch (e) {
        emit(state.copyWith(loading: false, error: 'Email / Password salah!'));
      }
    });

    on<SignOut>((event, emit) async {
      try {
        await authenticationRepository.signOut();
        emit(state.copyWith(status: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}
