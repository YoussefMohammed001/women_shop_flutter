import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/cart_screen.dart';
import 'package:women_shop/fav_screen.dart';
import 'package:women_shop/home_screen.dart';
import 'package:women_shop/profile_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int index =0;
  List<String> tiltes = ["Home","Favorite","Cart","Profile"];
  List<Widget> screens = [HomeScreen(),FavoritScreen(),CartScreen(),ProfileScreen()];
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
          bottomNavigationBar: buildBottomNavigationBar(),
          body: Column(
            children: [
Container(
  padding: EdgeInsets.all(20),
  color: Colors.blue[900],
  child:   Row(
    children: [
      Text("Welcome,$name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)
    ],
  ),
),
              screens[index],
            ],
          )
      ),
    );
  }

  Widget buildBottomNavigationBar(){
    return BottomNavigationBar(

      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {
        print(value);
        index = value;
        setState(() {});
      },
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home_filled,),
        ),

        BottomNavigationBarItem(
          label: "Favorite",
          icon: Icon(Icons.favorite_border_outlined),
        ),

        BottomNavigationBarItem(
          label: "Cart",
          icon: Icon(Icons.shopping_cart_outlined,),
        ),

        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(Icons.person_outline,),
        ),




      ],
    );
  }
}
