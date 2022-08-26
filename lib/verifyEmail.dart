import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/main_home_screen.dart';
import 'package:women_shop/utils.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;



  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
if(!isEmailVerified){
  sendVerificationEmail();

  timer = Timer.periodic(
    Duration(
    seconds: 3
    ),
      (_) => checkEmailVerified(),

  );
}

  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified) timer?.cancel();
  }



  Future sendVerificationEmail() async{
  try{
    final user  = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  } catch (e){
    Utils.showSnackBar(e.toString());
  }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified ?
      MainHomeScreen() : SafeArea(

        child: Scaffold(
backgroundColor: Colors.pink,

    body: Center(
      child: Container(

          height: 100,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey[200]),

          child: Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A verification Email has been sent to your email"
                , style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 18),
                ),
                Text("You Must Verify Your Email to confirm Your Registeration"
                  , style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 13),
                ),
                ElevatedButton(onPressed: () {
                  FirebaseAuth.instance.signOut();

                }, child: const Text("Cancel"))



              ],
            ),
          ),
      ),
    ),

  ),
      );

  }

