class BankTransactionData {
  final String userId;
  final String accountName;
  final String bankName;
  final String bankIBAN;
  final int transactionId;
  final double amount;
  final bool isPending;
  final DateTime createdAt;
  final String receiptImg;

  const BankTransactionData({
    required this.userId,
    required this.accountName,
    required this.bankName,
    required this.bankIBAN,
    required this.transactionId,
    required this.amount,
    required this.isPending,
    required this.createdAt,
    required this.receiptImg,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'account_name': accountName,
      'bank_name': bankName,
      'bank_iban': bankIBAN,
      'transaction_id': transactionId,
      'amount': amount,
      'is_pending': isPending,
      'created_at': createdAt.millisecondsSinceEpoch,
      'receipt_img_url': receiptImg,
    };
  }

  factory BankTransactionData.fromMap(Map<String, dynamic> map) {
    return BankTransactionData(
      userId: map['user_id'] as String,
      accountName: map['account_name'] as String,
      bankName: map['bank_name'] as String,
      bankIBAN: map['bank_iban'] as String,
      transactionId: map['transaction_id'] as int,
      amount: map['amount'] as double,
      isPending: map['is_pending'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      receiptImg: map['receipt_img_url'] as String,
    );
  }
}
