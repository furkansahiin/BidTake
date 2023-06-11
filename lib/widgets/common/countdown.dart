import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  final Duration remainingTime;

  const CountdownTimer({required this.targetDate, required this.remainingTime});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.remainingTime;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (remainingTime.inSeconds <= 0) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        remainingTime = remainingTime - Duration(seconds: 1);
      });

      if (remainingTime.inSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  String formatTime(Duration duration) {
    if (duration.inSeconds <= 0) {
      return 'Süre Bitti';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (days > 0) {
      return '$days gün kaldı';
    } else if (hours > 0) {
      return '$hours saat kaldı';
    } else if (minutes > 0) {
      return '$minutes dakika kaldı';
    } else if (seconds > 0) {
      return '$seconds saniye kaldı';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  Duration get remainingTimee => remainingTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(remainingTimee),
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}
