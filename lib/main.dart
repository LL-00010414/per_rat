import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:per_rat/firebase_options.dart';
import 'package:per_rat/screens/auth_page.dart';

// final theme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme.fromSeed(
//     brightness: Brightness.dark,
//     seedColor: const Color.fromARGB(255, 109, 95, 7),
//   ),
//   textTheme: GoogleFonts.robotoSerifTextTheme(),
// );

// new color update
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.robotoSerifTextTheme().copyWith(
    titleSmall: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const AuthPage(),
    );
  }
}
