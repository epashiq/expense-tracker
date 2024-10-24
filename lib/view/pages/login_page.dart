// import 'package:expense_tracker/controller/provider/auth_provider.dart';
// import 'package:expense_tracker/view/pages/sign_up_page.dart';
// import 'package:expense_tracker/view/widgets/submit_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       backgroundColor: const Color(0XFFfafafaff),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 40),
//             const Text(
//               "Welcome Back",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Log in to your account to continue",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 40),
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color(0XFFffffffff),
//                 prefixIcon: const Icon(Icons.mail),
//                 hintText: 'Email',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color(0XFFffffffff),
//                 prefixIcon: const Icon(Icons.lock),
//                 hintText: 'Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SubmitButtonWidget(
//               btnText: 'Login',
//               onTap: () {
//                 authProvider.login(
//                     emailController.text, passwordController.text, context);
//               },
//               emailController: emailController,
//               passController: passwordController,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 authProvider.signInWithGoogle(context);
//                 // Navigator.pushReplacement(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) => const AddExpensePage(),
//                 //     ));
//               },
//               icon: Image.network(
//                 'https://www.freepnglogos.com/uploads/new-google-logo-transparent--14.png',
//                 height: 24.0,
//               ),
//               label: const Text(
//                 'Sign in with Google',
//                 style: TextStyle(fontSize: 15),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   side: const BorderSide(color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Don't have an account? ",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignUpPage(),
//                         ));
//                   },
//                   child: const Text(
//                     "Register",
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:expense_tracker/controller/provider/auth_provider.dart';
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:expense_tracker/view/pages/sign_up_page.dart';
import 'package:expense_tracker/view/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0XFFfafafaff),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Log in to your account to continue",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: currentTheme.colorScheme.surface,
                  prefixIcon: const Icon(Icons.mail),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation regex
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  if (!RegExp(pattern).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: currentTheme.colorScheme.surface,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SubmitButtonWidget(
                btnText: 'Login',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.login(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                  }
                },
                emailController: emailController,
                passController: passwordController,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  authProvider.signInWithGoogle(context);
                },
                icon: Image.network(
                  'https://www.freepnglogos.com/uploads/new-google-logo-transparent--14.png',
                  height: 24.0,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentTheme.colorScheme.surface,
                  foregroundColor:
                      themeProvider.isDarkmode ? Colors.white : Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
