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
    return  Scaffold(


      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.pink,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: buildCustomSearch()),
                Center(
                  child: Container(
margin: EdgeInsets.only(bottom: 10),

                    child: IconButton(onPressed: () {

                    }, icon: IconButton(icon: Icon(Icons.shopping_cart,size: 33,),color: Colors.white, onPressed: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));

                    },)),
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(


                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    buildCategoryList(),
                    Text(" Best Items",style: TextStyle(color: Colors.pink,fontSize: 25,fontWeight: FontWeight.bold),),


                    buildBestItemsList(),

                    Text(" New Items",style: TextStyle(color: Colors.pink,fontSize: 25,fontWeight: FontWeight.bold),),
                    buildNewItemsList()



                  ],
                ),
              ),
            ),
          )
        ],
      ),


    );
  }

  Widget buildCategoryList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("category").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.all(10),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return categoryItem(index, data);
                    },
                  ),
                ),
              ),
            ],
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
            category = "Acsesories";
            break;
          case 1:
            category = "Bath and Body";
            break;
          case 2:
            category = "Beauty";
            break;
          case 3:
            category = "Dresses";
            break;
          case 4:
            category = "Kitchen";
            break;
          case 5:
            category = "Pants";
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
          return Column(
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.all(10),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return bestItem(index, data);
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },


    );
  }
  Widget bestItem(index, data) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
      child: InkWell(
        onTap: (){
          String category = "Bes Items";
          FirebaseFirestore.instance.collection('Best Items').get()
              .then((value) {
            List<Map<dynamic, dynamic>> docs = [];
            for (var doc in value.docs) {
              docs.add(doc.data());
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => ModelDetails(docs[index])));

            //m
          });
        },
        child: Row(

          children: [

              Image.network(data['image'],width: 150,height: 150,),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text(data['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
                Text(data['price']),
              ],
            ),

          ],
        ),
      ),
    );
  }


  Widget buildNewItemsList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("New Items").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {

          return Container(
            height: double.infinity,

            width: double.infinity,


            child: ListView.builder(

              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];

                return InkWell(
                  onTap: () {

                    FirebaseFirestore.instance.collection('New Items').get()
                        .then((value) {
                      List<Map<dynamic, dynamic>> docs = [];
                      for (var doc in value.docs) {
                        docs.add(doc.data());
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ModelDetails(docs[index])));

                      //m
                    });

                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10,top: 10,bottom: 10,left: 10),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),

                    child: Row(

                      children: [

                          Image.network(data['image'],height: 100,width: 100,),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(data['price']),
                          ],
                        ),
                        Spacer(),


                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.docs.length,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }



  Widget buildCustomSearch(){
    return Container(

      margin: EdgeInsets.only(left: 5,top: 5),
      decoration:BoxDecoration(borderRadius:BorderRadius.circular(5),color: Colors.pink ),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: " Search",
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.search,color: Colors.white,),

            border: InputBorder.none
        ),
      ),
    );



  }






}
