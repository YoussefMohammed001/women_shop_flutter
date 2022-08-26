import 'package:flutter/material.dart';
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
  List<String> tiltes = ["Home","Favorite","Profile"];
  List<Widget> screens = [HomeScreen(),FavoritScreen(),ProfileScreen()];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: buildBottomNavigationBar(),
          body: screens[index]
      ),
    );
  }

  Widget buildBottomNavigationBar(){
    return BottomNavigationBar(

      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.pink,
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
          label: "Profile",
          icon: Icon(Icons.person_outline,),
        ),



      ],
    );
  }
}
