import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/main.dart';
import 'package:women_shop/my_text_field.dart';
import 'package:women_shop/signin_screen.dart';
import 'package:women_shop/utils.dart';
import 'package:women_shop/verifyEmail.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isNotVisible = true;
  bool isConfirmPassNotVisible = true;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var confirmPasswordController = TextEditingController();


  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account"),),

body: Container(
  margin: EdgeInsets.all(20),
  child:   Form(
    key: _formKey,
    child: ListView(

      children: [

    MyTextField(
      prefxi: Icon(Icons.person),
      validator: (value){
        if(value!.isEmpty){
          return "Please enter your Name";
        }
      },
        controller: nameController,
        keyBoardType: TextInputType.text, lableText: "Your Name", textInputAction: TextInputAction.next, obscure: false),
    SizedBox(height: 5,),
    MyTextField(
        prefxi: Icon(Icons.email_outlined),
        validator: (value){
          if(value!.isEmpty){
            return "Please enter your Email";
          }
        },
        controller: emailController,
        keyBoardType: TextInputType.text, lableText: "Email", textInputAction: TextInputAction.next, obscure: false),
        SizedBox(height: 5,),
        MyTextField(

            prefxi: Icon(Icons.phone_android_outlined),
            validator: (value){
              if(value!.isEmpty){
                return "Please enter your Mobile Number";
              }
            },
            controller: phoneNumberController,
            keyBoardType: TextInputType.text, lableText: "mobile Number", textInputAction: TextInputAction.next, obscure: false),
        SizedBox(height: 5,),
        MyTextField(
          prefxi: Icon(Icons.password),
            suffixIcon: IconButton(onPressed: () {
              isNotVisible = !isNotVisible;
              setState(() {});
            }
                , icon: Icon(isNotVisible ? Icons.visibility_off_outlined : Icons.visibility ,color: Colors.blue[900],)),
            validator: (value){
              if(value!.isEmpty){
                return "Please enter your Password";
              }
            },
            controller: passwordController,
            keyBoardType: TextInputType.text, lableText: "Password", textInputAction: TextInputAction.next, obscure: isNotVisible),
        SizedBox(height: 5,),
        MyTextField(
            prefxi: Icon(Icons.password),
            suffixIcon: IconButton(onPressed: () {
              isConfirmPassNotVisible = !isConfirmPassNotVisible;
              setState(() {});
            }
                , icon: Icon(isConfirmPassNotVisible ? Icons.visibility_off_outlined : Icons.visibility ,color: Colors.blue[900],)),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please confirm your password";
            }
            if (passwordController.text != confirmPasswordController.text) {
              return "password doesn't match";
            }
          },
            controller: confirmPasswordController,
            keyBoardType: TextInputType.text, lableText: "Confirm Password", textInputAction: TextInputAction.next, obscure: isConfirmPassNotVisible),
SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: () {
               if(_formKey.currentState!.validate()){
                 signUp();
               }
              }, child: Text("Create Account")),
            ),
          ],
        )
      ],
    ),
  ),
),
    );
  }
  Future signUp() async{

    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(),),barrierDismissible: false);
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "${emailController.text.trim()}", password: "${passwordController.text.trim()}");
      String email = emailController.text.trim();
      String name = nameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();
      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmail(),)

      ).then((value) async{
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
          "uid": user?.uid,
          "name" :name ,
          "email": email,
          "phone number": phoneNumber
        });

      });
    } on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);

    }
    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }
}
