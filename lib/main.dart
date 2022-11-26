import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instatgram/state/backend/authenticator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home page')),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: (() async {
              final result = await Authenticator().loginWithGoogle();
              print(result);
            }),
            child: const Text('Sign In With Google'),
          ),
          TextButton(
            onPressed: (() async {
              final result = await Authenticator().loginWithFacebook();
              print(result);
            }),
            child: const Text('Sign In With Facebook'),
          )
        ],
      ),
    );
  }
}
