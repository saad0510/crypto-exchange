import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/errors/failures.dart';
import '../entities/peer_offer.dart';

class P2PRepo {
  final FirebaseFirestore firestore;

  const P2PRepo({required this.firestore});

  Stream<List<PeerOffer>> getOffers() => //
      firestore
          .collection("p2p_offers") //
          .snapshots()
          .map(
            (snap) => snap.docs //
                .map((doc) => PeerOffer.fromMap(doc.data()))
                .toList(),
          );

  Future<Result<Unit, P2PFailure>> addOffer(PeerOffer offer) //
      =>
      _catchErrors<Unit>(
        () async {
          final doc = firestore.collection("p2p_offers").doc();
          final newOffer = offer.copyWith(offerId: doc.id);
          await doc.set(newOffer.toMap());
          return unit;
        },
      );

  Future<Result<Unit, P2PFailure>> reduceOffer(PeerOffer offer, double amount) //
      =>
      _catchErrors<Unit>(
        () async {
          final offerAmountStr = offer.amount.toStringAsFixed(10);
          final amountStr = amount.toStringAsFixed(10);

          if (offerAmountStr == amountStr) {
            await firestore
                .collection("p2p_offers")
                .doc(offer.offerId) //
                .delete();
            return unit;
          }
          await firestore
              .collection("p2p_offers")
              .doc(offer.offerId) //
              .update({'amount': FieldValue.increment(-amount)});
          return unit;
        },
      );

  Future<Result<Unit, P2PFailure>> x(PeerOffer offer) //
      =>
      _catchErrors<Unit>(
        () async {
          return unit;
        },
      );

  Future<Result<ReturnType, P2PFailure>> _catchErrors<ReturnType>(
    Future<ReturnType> Function() function,
  ) async {
    try {
      return Success(await function());
    } on Exception catch (e) {
      return Error(P2PFailure(e.toString()));
    }
  }
}
