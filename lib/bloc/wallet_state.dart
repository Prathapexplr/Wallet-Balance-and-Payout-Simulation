import '../data/models/transaction.dart';

class WalletState {
  final double balance;
  final List<Transaction> transactions;

  WalletState({required this.balance, required this.transactions});

  WalletState copyWith({
    double? balance,
    List<Transaction>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}
