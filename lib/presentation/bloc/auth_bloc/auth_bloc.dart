import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_fly/domain/entities/user_entity.dart';
import 'package:foodie_fly/domain/repository/auth_repository.dart';
import 'package:foodie_fly/utils/constant/app_constant.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  Timer? _sessionCheckTimer;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckSessionTimeoutEvent>(_onCheckSessionTimeoutEvent);

    _startSessionCheck();
  }

  void _startSessionCheck() {
    _sessionCheckTimer?.cancel();
    _sessionCheckTimer = Timer.periodic(
      AppConstant.sessionCheckInterval,
      (_) => add(CheckSessionTimeoutEvent()),
    );
  }

  Future<void> _onCheckSessionTimeoutEvent(
    CheckSessionTimeoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isTimeOut = await _authRepository.checkSessionTimeout();
    if (isTimeOut) {
      emit(SessionTimeout());
      emit(UnAuthenticated());
    }
  }

  @override
  Future<void> close() {
    _sessionCheckTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.login(event.email, event.password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.register(event.email, event.password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final isLoggedIn = await _authRepository.isUserLoggedIn();

    if (isLoggedIn) {
      final user = await _authRepository.getUserData();

      user.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(UnAuthenticated());
  }
}
