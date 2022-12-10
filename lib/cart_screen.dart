import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_shop/model_details.dart';

class CartScreen extends StatelessWidget {
   CartScreen({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: SizedBox(
          height: double.infinity,
          child: fetchData("users-cart-items")),
    );
  }



  Widget fetchData (String collectionName) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items")
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something is wrong"),
          );
        }

        return ListView.builder(
            itemCount:
            snapshot.data == null ? 0 : snapshot.data!.docs.length,
            itemBuilder: (_, index) {

              DocumentSnapshot _documentSnapshot =
              snapshot.data!.docs[index];

              return InkWell(
                onTap: (){


                  FirebaseFirestore.instance
                      .collection(collectionName)
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection("items").get()
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
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),

                  child: Row(
                    children: [
                      Image.network("${_documentSnapshot['image']}",height: 100,width: 100,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_documentSnapshot['name']}",style: TextStyle(),maxLines: 1,),
                            Text("${_documentSnapshot['price']}"),
                          ],
                        ),
                      ),

                      IconButton(onPressed: () {
                        FirebaseFirestore.instance
                            .collection(collectionName)
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("items")
                            .doc(_documentSnapshot.id)
                            .delete();

                      }, icon: Icon(Icons.delete,color: Colors.red,))


                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
