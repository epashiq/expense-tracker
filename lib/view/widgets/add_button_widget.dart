
import 'package:flutter/material.dart';

class AddButtonWidget extends StatelessWidget {
  final String btnText;
  final void Function() onTap;
  final double width;
  final double? height;
  final TextEditingController? emailController;
  final TextEditingController? passController;

  const AddButtonWidget({
    super.key,
    required this.btnText,
    required this.onTap,
    required this.width,
    this.height,
    this.emailController,
    this.passController,
  });

  @override
  Widget build(BuildContext context,) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFb2bbc2),
            Color(0xFFb7c0c7),
            Color(0xFF8d95a1),
            Color(0xFF656d78),
            Color(0xFF313247),
            Color(0xFF21283b),
            Color(0xFF42485c),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: width ,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onTap,
        child: Text(
          btnText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
