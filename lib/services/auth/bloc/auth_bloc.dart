import 'package:bloc/bloc.dart';
import 'package:demonotes/services/auth/auth_provider.dart';
import 'package:demonotes/services/auth/bloc/auth_state.dart';

import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
