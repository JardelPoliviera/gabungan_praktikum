import 'package:flutter/material.dart';
import '../transaction_detail_screen.dart';
import '../../models/transaction_model.dart';
import '../../database/database_helper.dart';

class DashboardScreen extends StatefulWidget {
  final String email;
  const DashboardScreen({super.key, required this.email});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTransactions();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);
    transactions = await DatabaseHelper.instance.getAllTransactions();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Keuangan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            refreshTransactions(); 
          }
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo,',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.email, 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Transaksi Terakhir',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionList(context),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Utama',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              'Rp 52.000.000.000.000',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Belum ada transaksi', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.receipt, color: Colors.white),
            ),
            title: Text(tx.title),
            subtitle: Text(tx.date),
            trailing: Text(
              'Rp ${tx.amount}',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailScreen(
                    title: tx.title,
                    amount: 'Rp ${tx.amount}',
                    category: 'Umum', 
                    date: tx.date,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}