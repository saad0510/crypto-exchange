import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/errors/failures.dart';
import '../entities/bank_transaction_data.dart';
import '../entities/wallet_data.dart';

class WalletRepo {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const WalletRepo({
    required this.firestore,
    required this.storage,
  });

  Future<Result<WalletData, WalletFailure>> fetchWallet(String userId) => //
      _catchErrors<WalletData>(
        () async {
          final doc = await firestore
              .collection('wallets') //
              .doc(userId)
              .get();
          if (doc.exists == false) {
            return WalletData.empty();
          }
          final data = doc.data()!;
          final addr = data['address'] as String;
          data.remove('address');
          final coins = Map<String, num>.from(data);
          return WalletData(coins: coins, address: addr);
        },
      );

  Future<Result<Unit, WalletFailure>> depositAmount(
    String userId,
    String coinId,
    double amount,
  ) => //
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection('wallets') //
              .doc(userId)
              .update({coinId: FieldValue.increment(amount)});
          return unit;
        },
      );

  Future<Result<Unit, WalletFailure>> depositTransaction(BankTransactionData data) => //
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection('bank_deposits') //
              .doc(data.userId)
              .set(data.toMap());
          return unit;
        },
      );

  Future<Result<Unit, WalletFailure>> changeAddress(String userId, String address) => //
      _catchErrors<Unit>(
        () async {
          await firestore
              .collection('wallets') //
              .doc(userId)
              .update({'address': address});
          return unit;
        },
      );

  Future<Result<String, WalletFailure>> uploadReceipt(File image) => //
      _catchErrors<String>(
        () async {
          final filename = DateTime.now().microsecondsSinceEpoch.toString();
          final task = await storage
              .ref('receipts') //
              .child(filename)
              .putFile(image);
          return task.ref.getDownloadURL();
        },
      );

  Future<Result<ReturnType, WalletFailure>> _catchErrors<ReturnType>(
    Future<ReturnType> Function() function,
  ) async {
    try {
      return Success(await function());
    } on Exception catch (e) {
      return Error(WalletFailure(e.toString()));
    }
  }
}
