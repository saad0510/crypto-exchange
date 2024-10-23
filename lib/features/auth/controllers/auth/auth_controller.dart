import 'dart:io';

import '../../../../app/constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/base_change_notifier.dart';
import '../../entities/user_data.dart';
import '../../repositories/auth_repo.dart';
import '../../repositories/user_repo.dart';
import 'auth_state.dart';

class AuthController extends BaseChangeNotifier<AuthState> {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  AuthFailure? miscError;

  AuthController({
    required this.authRepo,
    required this.userRepo,
  }) : super(const AuthEmptyState(), debugMode: true);

  @override
  Future<void> init() async {
    state = const AuthLoadingState();
    final res = await authRepo.silentLogin();
    res.when(
      (userData) => state = AuthLoadedState(userData),
      (error) => state = const AuthEmptyState(),
    );
    await super.init();
  }

  UserData get user {
    if (state is AuthLoadedState) return (state as AuthLoadedState).data;
    return const UserData(
      uid: '',
      name: 'no name',
      email: '',
      phone: '',
      picUrl: '',
    );
  }

  void login(String email, String password) async {
    state = const AuthLoadingState();
    final res = await authRepo.login(email, password);
    res.when(
      (userData) => state = AuthLoadedState(userData),
      (failure) => state = AuthErrorState(failure),
    );
  }

  void register(UserData data, String password) async {
    state = const AuthLoadingState();
    final res = await authRepo.register(data, password);
    res.when(
      (userData) => state = AuthLoadedState(userData),
      (failure) => state = AuthErrorState(failure),
    );
  }

  void continueWithGoogle() async {
    state = const AuthLoadingState();
    final res = await authRepo.continueWithGoogle();
    res.when(
      (userData) => state = AuthLoadedState(userData),
      (failure) {
        if (failure.action == AppConstants.googleLoginRejectedCode) {
          state = const AuthEmptyState();
        } else {
          state = AuthErrorState(failure);
        }
      },
    );
  }

  Future<void> updateEmailAddr(String email) async {
    final oldUser = user;
    state = const AuthLoadingState();
    final res = await userRepo.changeEmail(email);
    miscError = res.tryGetError();

    if (res.isError()) {
      state = AuthLoadedState(oldUser);
      return;
    }

    final newUser = oldUser.copyWith(email: email);
    return updateUser(newUser);
  }

  Future<void> updateProfilePic(File imageFile) async {
    final oldUser = user;
    state = const AuthLoadingState();
    final res = await userRepo.uploadPicture(oldUser.uid, imageFile);
    miscError = res.tryGetError();

    if (res.isError()) {
      state = AuthLoadedState(oldUser);
      return;
    }

    final imageUrl = res.tryGetSuccess()!;
    final newUser = oldUser.copyWith(picUrl: imageUrl);
    return updateUser(newUser);
  }

  Future<void> updatePhoneNumber(String phoneNo) async {
    final newUser = user.copyWith(phone: phoneNo);
    return updateUser(newUser);
  }

  Future<void> updateUser(UserData newUser) async {
    final oldUser = user;
    state = const AuthLoadingState();
    final res = await userRepo.updateUser(newUser);
    miscError = res.tryGetError();
    res.when(
      (_) => state = AuthLoadedState(newUser),
      (failure) => state = AuthLoadedState(oldUser),
    );
  }

  void logout() async {
    state = const AuthLoadingState();
    final res = await authRepo.logout();
    res.when(
      (_) => state = const AuthEmptyState(),
      (failure) => state = AuthErrorState(failure),
    );
  }
}
