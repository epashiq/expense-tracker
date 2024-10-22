// import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
// import 'package:expense_tracker/controller/provider/auth_provider.dart';
// import 'package:expense_tracker/controller/provider/theme_provider.dart';
// import 'package:expense_tracker/firebase_options.dart';
// import 'package:expense_tracker/view/pages/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   const MyApp({super.key});

//   Future<bool> checkUserLoggedIn() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('user') != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => AddExpensesProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Expense Tracker',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }

import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
import 'package:expense_tracker/controller/provider/auth_provider.dart';
import 'package:expense_tracker/controller/provider/chart_provider.dart';
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/view/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  const MyApp({super.key});

  Future<bool> checkUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AddExpensesProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Added ThemeProvider here
                    ChangeNotifierProvider(create: (_) => ChartProvider()),

      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',
            theme: themeProvider.themeData, // Using dynamic theme here
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
