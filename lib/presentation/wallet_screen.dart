import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../data/models/transaction.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  void _confirmPayout(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.indigo, size: 42),
              const SizedBox(height: 12),
              Text(
                'Confirm Payout',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You are about to payout ₹${amount.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WalletBloc>().add(Payout(amount));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomPayoutDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.indigo, size: 20),
                  const SizedBox(height: 10),
                  Text(
                    ' Enter Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: GoogleFonts.poppins(),
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final val = double.tryParse(controller.text);
                      if (val != null && val > 0) {
                        Navigator.pop(context);
                        _confirmPayout(context, val);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionTile(Transaction txn) {
    final isSuccess = txn.status.contains('Success');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSuccess ? Colors.green[50] : Colors.red[50],
          child: Icon(
            isSuccess ? Icons.check : Icons.close,
            color: isSuccess ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          '₹${txn.amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          txn.time.toLocal().toString().split('.')[0],
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
        ),
        trailing: Text(
          txn.status,
          style: GoogleFonts.poppins(
            color: isSuccess ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.account_balance_wallet, color: Colors.indigo),
            const SizedBox(width: 8),
            Text(
              'My Wallet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: const AssetImage('assets/bg_wallet.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.indigo.withOpacity(0.15),
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '₹${state.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _showCustomPayoutDialog(context),
                      icon: const Icon(Icons.payments, color: Colors.indigo),
                      label: Text(
                        'Payout',
                        style: GoogleFonts.poppins(color: Colors.indigo),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Transaction History',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              state.transactions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "No transactions found",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    )
                  : Column(
                      children: state.transactions
                          .map((txn) => _transactionTile(txn))
                          .toList(),
                    ),
            ],
          );
        },
      ),
    );
  }
}
