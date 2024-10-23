import '../../../../core/errors/failures.dart';
import '../../entities/user_data.dart';

abstract class AuthState {
  const AuthState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthEmptyState extends AuthState {
  const AuthEmptyState();
}

class AuthLoadedState extends AuthState {
  final UserData data;
  const AuthLoadedState(this.data);

  bool get hasPhone => data.phone.isNotEmpty;
}

class AuthErrorState extends AuthState {
  final AuthFailure failure;
  const AuthErrorState(this.failure);
}
