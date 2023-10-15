import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mike/common/widgets/error.dart';
import 'package:mike/common/widgets/loader.dart';
import 'package:mike/features/auth/controller/auth_controller.dart';
import 'package:mike/features/landing/screens/landing_screen.dart';
import 'package:mike/firebase_options.dart';
import 'package:mike/router.dart';
import 'package:mike/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:mike/colors.dart';
import 'package:mike/screens/mobile_layout_screen.dart';
import 'package:mike/screens/web_layout_screen.dart';
import 'package:mike/utils/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp()
      ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MIKE',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
