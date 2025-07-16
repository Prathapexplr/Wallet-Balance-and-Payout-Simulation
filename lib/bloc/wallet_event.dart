abstract class WalletEvent {}

class StartStream extends WalletEvent {}

class Payout extends WalletEvent {
  final double amount;

  Payout(this.amount);
}
