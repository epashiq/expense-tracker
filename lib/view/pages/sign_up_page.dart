// import 'package:expense_tracker/view/widgets/submit_button_widget.dart';
// import 'package:flutter/material.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color(0XFFffffffff),
//                 prefixIcon: const Icon(Icons.mail),
//                 hintText: 'Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
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
//             const SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color(0XFFffffffff),
//                 prefixIcon: const Icon(Icons.mail),
//                 hintText: 'Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SubmitButtonWidget(
//               btnText: 'SignUp',
//               onTap: () {},
//               emailController: emailController,
//               passController: passwordController,
//               nameController: nameController,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:expense_tracker/view/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFfafafa),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Create an Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sign up to get started!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFFFFFFF),
                prefixIcon: const Icon(Icons.person),
                hintText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFFFFFFF),
                prefixIcon: const Icon(Icons.mail),
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFFFFFFF),
                prefixIcon: const Icon(Icons.lock),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SubmitButtonWidget(
              btnText: 'Sign Up',
              onTap: () {},
              emailController: emailController,
              passController: passwordController,
              nameController: nameController,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
