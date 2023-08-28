import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

Future<bool> checkBiometrics() async {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool canCheckBiometrics = await localAuth.canCheckBiometrics;
  final bool canAuthenticate =
      canCheckBiometrics || await localAuth.isDeviceSupported();
  return canAuthenticate;
}

Future<bool> authenticate() async {
  var localAuth = LocalAuthentication();

  bool canAuthenticate = await localAuth.canCheckBiometrics;
  if (canAuthenticate) {
    bool authenticated = false;

    try {
      authenticated = await localAuth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ));
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      // Fingerprint authentication successful
      // You can navigate to a secure part of your app here
      debugPrint("Fingerprint authentication success.");
      return true;
    } else {
      // Fingerprint authentication failed
      debugPrint("Fingerprint authentication failed.");
      exit(0);
      // return false;
    }
  } else {
    // Biometric authentication is not available on this device
    debugPrint("Biometric authentication is not available on this device.");
    exit(0);
    // return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample Fingerprint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sample Fingerprint'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
