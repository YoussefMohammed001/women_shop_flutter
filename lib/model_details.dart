import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:women_shop/cart_screen.dart';
import 'package:women_shop/reservation_screen.dart';

class ModelDetails extends StatefulWidget {
  ModelDetails(this.products,{Key? key}) : super(key: key);
  Map products;


  @override
  State<ModelDetails> createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
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

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({

      "name": widget.products["name"],
      "price": widget.products["price"],
      "image": widget.products["image"],
      'Description' :widget.products['Description']
    }).then((value) => print("Added to favourite"));
  }
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({

      "name": widget.products["name"],
      "price": widget.products["price"],
      "image": widget.products["image"],
      'Description' :widget.products['Description']
    }).then((value) => print("Added to favourite"));
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.products['name']}'),backgroundColor: Colors.blue[900],),

        body:Column(
          children: [
            Image.network(widget.products['image'],height: 250,width: double.infinity,fit: BoxFit.fill,),

            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue[900],
              child: Row(
                children: [
                  Text("${widget.products['name']}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text("${widget.products['price']}",style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),

                child: Text("${widget.products['description']}",style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold),)),
            Spacer(),
Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 20,right: 20),
    child: OutlinedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> GenerateQrCode(data: '${widget.products['name'] +"\n" +   FirebaseAuth.instance.currentUser!.email}')));}, child: Text("Reservation Now"))),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
              child: Row(

                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('items').where(
                        'name', isEqualTo: widget.products['name']).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Text("");


                      }
                      return     Expanded(
                        child: ElevatedButton(onPressed: () {
    snapshot.data.docs.length == 0? addToCart() : '';

    }, child:snapshot.data.docs.length == 0? Icon(Icons.add_shopping_cart_outlined): Icon(Icons.shopping_cart_checkout)),


                      );
                    },

                  ),

                  SizedBox(width: 5,),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users-favourite-items").doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('items').where(
                        'name', isEqualTo: widget.products['name']).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Text("");

                      }
return     Expanded(
  child:   ElevatedButton(onPressed: () {
    snapshot.data.docs.length == 0? addToFavourite() : "";

  }, child:snapshot.data.docs.length == 0? Icon(Icons.favorite_border): Icon(Icons.favorite)),
);
                    },

                  ),
                ],
              ),
            )




          ],
        ),
      ),
    );



  }
}


