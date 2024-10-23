import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../app/constants.dart';
import '../../../core/errors/failures.dart';
import '../entities/user_data.dart';

class UserRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const UserRepo({
    required this.auth,
    required this.firestore,
    required this.storage,
  });

  Future<Result<Unit, AuthFailure>> updateUser(UserData data) //
      =>
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection("users") //
              .doc(data.uid)
              .set(data.toMap());
          return unit;
        },
      );

  Future<Result<String, AuthFailure>> uploadPicture(String filename, File file) //
      async =>
      _catchErrors<String>(
        () async {
          final task = await storage
              .ref('images') //
              .child(filename)
              .putFile(file);
          return await task.ref.getDownloadURL();
        },
      );

  Future<Result<Unit, AuthFailure>> changeEmail(String email) //
      async =>
      _catchErrors<Unit>(
        () async {
          final user = auth.currentUser;
          if (user == null) {
            throw FirebaseAuthException(
              code: AppConstants.nullUserCode,
              message: AppConstants.nullUserError,
            );
          }
          await user.updateEmail(email);
          return unit;
        },
      );

  Future<Result<UserData, AuthFailure>> getUser(String uid) //
      async =>
      _catchErrors<UserData>(
        () async {
          final doc = await firestore
              .collection("users") //
              .doc(uid)
              .get();
          return UserData.fromMap(doc.data()!);
        },
      );

  Future<Result<Iterable<UserData>, AuthFailure>> getUsers(List<String> uids) //
      async =>
      _catchErrors<Iterable<UserData>>(
        () async {
          final snap = await firestore
              .collection("users") //
              .where("uid", arrayContainsAny: uids)
              .get();
          return snap.docs.map(
            (doc) => UserData.fromMap(doc.data()),
          );
        },
      );

  Future<Result<ReturnType, AuthFailure>> //
      _catchErrors<ReturnType>(Future<ReturnType> Function() function) async {
    try {
      return Success(await function());
    } on FirebaseException catch (e) {
      return Error(AuthFailure(e.code, '${e.message}'));
    } on Exception catch (e) {
      return Error(AuthFailure('unknown', e.toString()));
    }
  }
}
