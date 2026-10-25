import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../database/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController(); // Controller untuk tanggal

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        String day = picked.day.toString().padLeft(2, '0');
        String month = picked.month.toString().padLeft(2, '0');
        String year = picked.year.toString();
        _dateController.text = "$day/$month/$year";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catat Transaksi"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Judul
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // Input Nominal
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                readOnly: true, 
                decoration: InputDecoration(
                  labelText: "Tanggal Transaksi (DD/MM/YYYY)",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: (value) =>
                    value == null || value.isEmpty ? "Tanggal wajib diisi!" : null,
              ),
              const SizedBox(height: 32),

              // Tombol Simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 1. Simpan ke SQLite
                    final newTransaction = TransactionModel(
                      title: _titleController.text,
                      amount: _amountController.text,
                      date: _dateController.text,
                    );
                    await DatabaseHelper.instance.insertTransaction(newTransaction);

                    // 2. Tampilkan Notifikasi
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaksi Berhasil Disimpan!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // 3. Kembali ke Dashboard
                      Navigator.pop(context, true); 
                    }
                  }
                },
                child: const Text("Simpan", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}