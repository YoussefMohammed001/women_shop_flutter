import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModelDetails extends StatefulWidget {
  ModelDetails(this.products,{Key? key}) : super(key: key);
  Map products;


  @override
  State<ModelDetails> createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.products['name']}'),),

        body:Column(
          children: [
            Image.network(widget.products['image'],height: 250,width: double.infinity,fit: BoxFit.fill,),

            Container(
              padding: EdgeInsets.all(20),
              color: Colors.pink,
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

                child: Text("${widget.products['Description']}",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)),
            Spacer(),

            Container(
              margin: EdgeInsets.all(20),
              child: Row(

                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: () {

                    }, child: Text("order")),
                  ),
SizedBox(width: 5,),
                  ElevatedButton(onPressed: () {

                  }, child: Icon(Icons.add_shopping_cart_outlined)),
                  SizedBox(width: 5,),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users-favourite-items").doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('items').where(
                        'name', isEqualTo: widget.products['name']).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Text("");

                      }
return     ElevatedButton(onPressed: () {
  snapshot.data.docs.length == 0? addToFavourite() : "already add";

}, child:snapshot.data.docs.length == 0? Icon(Icons.favorite_border): Icon(Icons.favorite));
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


