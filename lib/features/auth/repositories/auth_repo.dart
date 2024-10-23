import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../app/constants.dart';
import '../entities/user_data.dart';

class AuthRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AuthRepo({
    required this.auth,
    required this.firestore,
  });

  Future<bool> get isVerified async {
    await auth.currentUser?.reload();
    return auth.currentUser?.emailVerified ?? false;
  }

  Future<Result<Unit, AuthFailure>> sendVerificationEmail() => //
      _catchErrors<Unit>(
        () async {
          await auth.currentUser!.sendEmailVerification();
          return unit;
        },
      );

  Future<Result<UserData, AuthFailure>> login(
    String email,
    String password,
  ) =>
      _catchErrors<UserData>(
        () async {
          await auth.signInWithEmailAndPassword(email: email, password: password);
          final user = auth.currentUser!;

          final doc = await firestore
              .collection("users") //
              .doc(user.uid)
              .get();

          return UserData.fromMap(doc.data()!);
        },
      );

  Future<Result<UserData, AuthFailure>> register(
    UserData data,
    String password,
  ) =>
      _catchErrors<UserData>(
        () async {
          await auth.createUserWithEmailAndPassword(email: data.email, password: password);
          final user = auth.currentUser!;

          final dataWithUid = data.copyWith(uid: user.uid);
          await firestore
              .collection("users") //
              .doc(user.uid)
              .set(dataWithUid.toMap());
          await firestore
              .collection("wallets") //
              .doc(user.uid)
              .set({'address': ''});

          return dataWithUid;
        },
      );

  Future<Result<UserData, AuthFailure>> silentLogin() //
      =>
      _catchErrors<UserData>(
        () async {
          final user = auth.currentUser;
          if (user == null) {
            throw FirebaseAuthException(
              code: AppConstants.nullUserCode,
              message: AppConstants.nullUserError,
            );
          }

          final doc = await firestore
              .collection("users") //
              .doc(user.uid)
              .get();

          return UserData.fromMap(doc.data()!);
        },
      );

  Future<Result<Unit, AuthFailure>> logout() //
      =>
      _catchErrors<Unit>(
        () async {
          await auth.signOut();
          await GoogleSignIn().signOut();
          return unit;
        },
      );

  Future<Result<Unit, AuthFailure>> sendResetEmail(String email) //
      =>
      _catchErrors<Unit>(
        () async {
          await auth.sendPasswordResetEmail(email: email);
          return unit;
        },
      );

  Future<Result<UserData, AuthFailure>> continueWithGoogle() //
      =>
      _catchErrors<UserData>(
        () async {
          final googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            throw FirebaseAuthException(
              code: AppConstants.googleLoginRejectedCode,
              message: AppConstants.googleLoginRejectedError,
            );
          }

          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final credits = await FirebaseAuth.instance.signInWithCredential(credential);
          final data = UserData.fromGoogleUser(credits.user!);

          final doc = firestore.collection("users").doc(data.uid);
          final docData = await doc.get();
          if (docData.exists == false) {
            await doc.set(data.toMap());
            return data;
          }
          return UserData.fromMap(docData.data()!);
        },
        onError: () => GoogleSignIn().signOut(),
      );

  Future<Result<ReturnType, AuthFailure>> //
      _catchErrors<ReturnType>(
    Future<ReturnType> Function() function, {
    void Function()? onError,
  }) async {
    try {
      return Success(await function());
    } on FirebaseException catch (e) {
      return Error(AuthFailure(e.code, '${e.message}'));
    } on Exception catch (e) {
      onError == null ? null : onError();
      return Error(AuthFailure('unknown', e.toString()));
    }
  }
}
