import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haica/shared/constant.dart';
import 'package:haica/shared/showsnackbar.dart';

class FogetPassword extends StatefulWidget {
  
  const FogetPassword({super.key});

  @override
  State<FogetPassword> createState() => _FogetPasswordState();
}

class _FogetPasswordState extends State<FogetPassword> {
  forgedtPasswor()async{
    try {
      await FirebaseAuth.instance
    .sendPasswordResetEmail(email: emailController.text);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    showSnackBar(context, "Check your email");
    emailController.clear();
    
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showSnackBar(context, "Error => $e");
    }
  }

    bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const  Text("Forget Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 50,),
          Center(
                child: SvgPicture.asset(
                  'assets/images/pass.svg',
                  height: 100.0,
                  width: 100.0,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
               const SizedBox(height: 30,),
               const Text("Forgett Password ?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),), 
               const SizedBox(height: 15,), 
               const Text("Enter the email adress associated", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),),
                const SizedBox(height: 10,), 
               const Text("with your account.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: greyColor),),
            const SizedBox(height: 30,),
          Container(
                  decoration: BoxDecoration(
                      color: tFieldgreyColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      style: const TextStyle(color: blackColor),
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.email,
                          color: greyColor,
                        ),
                        hintText: "Enter Your Email : ",
                        hintStyle: TextStyle(color: greyColor, fontSize: 17),
                      ),
                    ),
                  ),
                ),
       const SizedBox(height: 30,), 
       Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                      await forgedtPasswor();
                      
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        padding: isLoading
                            ? MaterialStateProperty.all(const EdgeInsets.all(5))
                            : MaterialStateProperty.all(
                                const EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 19, color: whiteColor),
                            ),
                    ),
                  ),
                ],
              ),
        ],
            ),
      )
 ,
    ); }
}