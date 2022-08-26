import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name= "";
  String email= "";
  String phoneNumber= "";


  Future _getDataFromDatabase() async{
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((snapshot) async{
      if(snapshot.exists){
        setState(() {
          name = snapshot.data()!['name'];
          email  = snapshot.data()!['email'];
          phoneNumber =  snapshot.data()!['phone number'];

        });
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink,

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(


                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),

                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Column(children: [

                  Text("$name",style: TextStyle(color: Colors.pink,fontSize: 22,fontWeight: FontWeight.bold),),
                  Text("$phoneNumber",style: TextStyle(color: Colors.pink,fontSize: 22,fontWeight: FontWeight.bold),),
                  Text("$email",style: TextStyle(color: Colors.pink,fontSize: 22,fontWeight: FontWeight.bold),),
                  Center(

                    child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(20),
                        child: ElevatedButton(onPressed: () => FirebaseAuth.instance.signOut(), child: Text("sign out",style: TextStyle(color: Colors.white),))),
                  ),




                ],),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
