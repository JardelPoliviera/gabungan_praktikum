import 'package:flutter/material.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/login_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker Final',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
    );
  }
}