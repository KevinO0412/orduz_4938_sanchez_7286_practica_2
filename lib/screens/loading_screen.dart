import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String userName;

  const LoadingScreen({
    super.key,
    required this.userName,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6fffb),
      body: Center(
        child: Card(
          elevation: 18,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
            width: 430,
            padding: const EdgeInsets.all(34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/neuro_ciencia_logo.png',
                  width: 170,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  'Bienvenido, ${widget.userName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xff64748b)),
                ),
                const SizedBox(height: 28),
                const LinearProgressIndicator(
                  minHeight: 6,
                  valueColor: AlwaysStoppedAnimation(Color(0xff00b8c4)),
                  backgroundColor: Color(0xffdbeafe),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Cargando sistema de optimización...',
                  style: TextStyle(color: Color(0xff64748b)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
