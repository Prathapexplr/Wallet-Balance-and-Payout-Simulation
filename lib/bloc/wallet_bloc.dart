import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/transaction.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  late StreamSubscription _streamSub;
  final _controller = StreamController<double>();
  double _mockBalance = 1700;

  WalletBloc() : super(WalletState(balance: 1700, transactions: [])) {
    on<StartStream>(_startStream);
    on<Payout>(_handlePayout);
  }

  void _startStream(StartStream event, Emitter<WalletState> emit) {
    _streamSub =
        Stream.periodic(const Duration(seconds: 3), (_) {
          _mockBalance + -10;
          return _mockBalance;
        }).listen((value) {
          emit(state.copyWith(balance: value));
        });
  }

  void _handlePayout(Payout event, Emitter<WalletState> emit) {
    if (state.balance >= event.amount) {
      final updatedBalance = state.balance - event.amount;
      final transaction = Transaction(
        amount: event.amount,
        time: DateTime.now(),
        status: 'Success',
      );
      final updatedTransactions = [transaction, ...state.transactions];
      _mockBalance = updatedBalance;
      emit(
        WalletState(balance: updatedBalance, transactions: updatedTransactions),
      );
    } else {
      final transaction = Transaction(
        amount: event.amount,
        time: DateTime.now(),
        status: 'Failed',
      );
      final updatedTransactions = [transaction, ...state.transactions];
      emit(state.copyWith(transactions: updatedTransactions));
    }
  }

  @override
  Future<void> close() {
    _streamSub.cancel();
    _controller.close();
    return super.close();
  }
}
