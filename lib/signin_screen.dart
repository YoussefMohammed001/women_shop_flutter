import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/forget_password.dart';
import 'package:women_shop/main.dart';
import 'package:women_shop/main_home_screen.dart';
import 'package:women_shop/my_text_field.dart';
import 'package:women_shop/sign_up.dart';
import 'package:women_shop/utils.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isNotVisible = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  void dispose(){

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,

          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10),



            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [




                MyTextField(
                   controller: emailController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return"please enter your email";

                    }
                  },
                  keyBoardType: TextInputType.emailAddress, lableText: "Email", textInputAction: TextInputAction.next, obscure:false,
                  prefxi: Icon(Icons.email_outlined,color: Colors.blue[900],),
                ),
                SizedBox(height: 10,),
                MyTextField(

            controller: passwordController,
            validator: (value) {
              if(value == null || value.isEmpty){
                return"please enter your password";

              }
            },
            obscure: isNotVisible,keyBoardType: TextInputType.visiblePassword, lableText: "Password", textInputAction: TextInputAction.done,
            prefxi: Icon(Icons.password,color: Colors.blue[900],),

            suffixIcon: IconButton(onPressed: () {
              isNotVisible = !isNotVisible;
              setState(() {});
              }
              , icon: Icon(isNotVisible ? Icons.visibility_off_outlined : Icons.visibility ,color: Colors.blue[900],)),

        ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword(),));


                  }, child: Text("Forget Password")),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 10),

                          child: ElevatedButton(onPressed: (){
                            if(_formKey.currentState!.validate()){
                              signIn();
                            }
                          } ,child: Text("Sign in"))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text("Don't Have Account?"),
                    TextButton(onPressed: () {
Navigator.push(context,  MaterialPageRoute(builder: (context) => SignUp(),));
                    }, child: Text("Sign Up"))

                  ],
                ),



              ],
            ),
          ),
        ),

      ),
    );
  }


  Future signIn() async{
    showDialog(context: context,
        builder: (context)
        => Center(child: CircularProgressIndicator(),)
        ,barrierDismissible: false);
    try{

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: "${emailController.text.trim()}", password: "${passwordController.text.trim()}");
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainHomeScreen(),)

      );
    } on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);


    }
    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }
}
