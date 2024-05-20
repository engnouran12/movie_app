import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/features/Auth_features/data/datasource/remote_data_source.dart';
import 'package:movie_app/features/Auth_features/presentation/cubit/auth_state.dart';


class AuthCubit extends Cubit<AuthState>  {
  final TMDBAuth tmdbAuth;

  AuthCubit({required this.tmdbAuth}) : super(AuthInitial());

  Future<void> checkLoginStatus() async {
    try {
      await tmdbAuth.checkLoginStatus();
      if (tmdbAuth.sessionId != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      await tmdbAuth.getRequestToken();
      await tmdbAuth.validateWithLogin(username, password);
      await tmdbAuth.createSession();
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await tmdbAuth.logout();
    emit(AuthUnauthenticated());
  }

 
}
