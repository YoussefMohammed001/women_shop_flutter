import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/cart_screen.dart';
import 'package:women_shop/category%20models.dart';
import 'package:women_shop/model_details.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstName= "";
  String lastName= "";
  String email= "";
  String phoneNumber= "";


  Future _getDataFromDatabase() async{
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((snapshot) async{
      if(snapshot.exists){
        setState(() {
          firstName = snapshot.data()!['first name'];
          lastName = snapshot.data()!['last name'];
          email  = snapshot.data()!['email'];
          phoneNumber =  snapshot.data()!['mobile number'];

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
    return Expanded(
      child: ListView(
        children: [
          buildCategoryList(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "New Products",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
          buildBestItemsList(),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 100,
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return categoryItem(index, data);
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  Widget categoryItem(index, data) {
    return InkWell(
      onTap: () {
        String category = "";
        switch (index) {
          case 0:
            category = "Adventure";
            break;
          case 1:
            category = "Crime";
            break;
          case 2:
            category = "History";
            break;
          case 3:
            category = "Horror";
            break;
          case 4:
            category = "Programming";
            break;
          case 5:
            category = "Science";
            break;
            case 6:
            category = "War";
            break;




        }
        FirebaseFirestore.instance.collection('category')
            .doc(category)
            .collection(category)
            .get()
            .then((value) {
          List<Map> docs =[];
          for (var doc in value.docs) {
            docs.add(doc.data());
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryModels(category,docs)));
        });

      },
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(data['image']),
                radius: 30,
              ),
              Text(data['name']),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBestItemsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Best Items").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return bestItem(index, data);
              }, gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },


    );
  }
  Widget bestItem(index, data) {
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance.collection('Best Items').get()
            .then((value) {
          List<Map<dynamic, dynamic>> docs = [];
          for (var doc in value.docs) {
            docs.add(doc.data());
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => ModelDetails(docs[index])));
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.network(
                data["image"],
                height: 90,
                width: 90,
                fit: BoxFit.fitWidth,

              ),
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              data['name'],
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              data['price'],
              style: const TextStyle(color: Colors.pink),
            ),
            SizedBox(
              width: 2,
            ),

          ],

        ),
      ),
    );
  }








}
