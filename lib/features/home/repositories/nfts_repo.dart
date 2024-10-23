import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/errors/failures.dart';
import '../entities/nft_data.dart';

class NFTsRepo {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const NFTsRepo({required this.storage, required this.firestore});

  Stream<List<NFTData>> allNFTsStream() => //
      firestore //
          .collection('nfts')
          .snapshots()
          .map(
            (snap) => snap.docs //
                .map((doc) => NFTData.fromMap(doc.data()))
                .toList(),
          );

  Future<Result<String, NFTsFailure>> uploadNFTImage(File imageFile) => //
      _catchErrors<String>(
        () async {
          final filename = DateTime.now().millisecondsSinceEpoch;
          final ref = await storage.ref('nfts/$filename').putFile(imageFile);
          return await ref.ref.getDownloadURL();
        },
      );

  Future<Result<NFTData, NFTsFailure>> addNFt(NFTData nft) => //
      _catchErrors<NFTData>(
        () async {
          final doc = firestore.collection('nfts').doc();
          nft = nft.copyWith(nftId: doc.id);
          await doc.set(nft.toMap());
          return nft;
        },
      );

  Future<Result<Unit, NFTsFailure>> changeOwnership(String nftId, String ownerId) => //
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection('nfts') //
              .doc(nftId)
              .update({
            "available": false,
            "owner_id": ownerId,
          });
          return unit;
        },
      );

  Future<Result<Unit, NFTsFailure>> updateNft(NFTData nft) => //
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection('nfts') //
              .doc(nft.nftId)
              .update(nft.toMap());
          return unit;
        },
      );

  Future<Result<ReturnType, NFTsFailure>> _catchErrors<ReturnType>(
    Future<ReturnType> Function() function,
  ) async {
    try {
      return Success(await function());
    } on Exception catch (e) {
      return Error(NFTsFailure(e.toString()));
    }
  }
}
