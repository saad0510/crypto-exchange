import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/errors/failures.dart';
import '../entities/stak_data.dart';

class StakRepo {
  final FirebaseFirestore firestore;

  const StakRepo({required this.firestore});

  Stream<List<StakData>> getStaksOf(String ownerId) => //
      firestore
          .collection("staks") //
          .where('owner_id', isEqualTo: ownerId)
          .snapshots()
          .map(
            (snap) => snap.docs //
                .map((doc) => StakData.fromMap(doc.data()))
                .toList(),
          );

  Future<Result<Unit, StakFailure>> addStak(StakData stak) => //
      _catchErrors<Unit>(
        () async {
          final doc = firestore.collection("staks").doc();
          final newStak = stak.copyWith(stkId: doc.id);
          await doc.set(newStak.toMap());
          return unit;
        },
      );

  Future<Result<Unit, StakFailure>> deleteStak(String stakId) => //
      _catchErrors<Unit>(
        () async {
          await firestore //
              .collection("staks")
              .doc(stakId)
              .delete();
          return unit;
        },
      );

  Future<Result<Unit, StakFailure>> updateStak(StakData stak) => //
      _catchErrors<Unit>(
        () async {
          await firestore //
              .collection("staks")
              .doc(stak.stkId)
              .update(stak.toMap());
          return unit;
        },
      );

  Future<Result<ReturnType, StakFailure>> _catchErrors<ReturnType>(
    Future<ReturnType> Function() function,
  ) async {
    try {
      return Success(await function());
    } on Exception catch (e) {
      return Error(StakFailure(e.toString()));
    }
  }
}
