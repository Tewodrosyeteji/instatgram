import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instatgram/state/providers/is_loading_provider.dart';
import 'package:instatgram/views/components/loading/loading_screen.dart';
import 'package:instatgram/views/login/login_view.dart';
import 'package:instatgram/views/main/main_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
    child: MaterialApp(
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
      home: Consumer(builder: ((context, ref, child) {
        ref.listen<bool>(
          isLoadingProvider,
          (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(
                context: context,
              );
            } else {
              LoadingScreen.instance().hide();
            }
          },
        );

        final isloggedin = ref.watch(isLoogedInProvider);
        if (isloggedin) {
          return const MainView();
        } else {
          return const LoginView();
        }
      })),
    ),
  ));
}
