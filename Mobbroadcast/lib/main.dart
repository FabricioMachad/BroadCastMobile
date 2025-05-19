import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Bateria',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BatteryMonitorScreen(),
    );
  }
}

class BatteryMonitorScreen extends StatefulWidget {
  const BatteryMonitorScreen({super.key});

  @override
  State<BatteryMonitorScreen> createState() => _BatteryMonitorScreenState();
}

class _BatteryMonitorScreenState extends State<BatteryMonitorScreen> {
  final Battery _battery = Battery();
  late Timer _timer;
  int _batteryLevel = 100;
  bool _alertShown = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) async {
      final level = await _battery.batteryLevel;
      setState(() => _batteryLevel = level);

      if (level < 30 && !_alertShown) {
        _alertShown = true;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Bateria abaixo de 30%!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (level >= 30) {
        _alertShown = false;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _openGitHubProfile() async {
    final url = Uri.parse('https://github.com/FabricioMachad');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o GitHub';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bateria')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nível de bateria: $_batteryLevel%', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _openGitHubProfile,
              icon: const Icon(Icons.link),
              label: const Text('Acessar GitHub'),
            )
          ],
        ),
      ),
    );
  }
}
