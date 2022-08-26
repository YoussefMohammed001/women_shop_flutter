import 'package:flutter/material.dart';
import 'package:women_shop/model_details.dart';

class CategoryModels extends StatefulWidget {
  CategoryModels(this.category,this.docs,{Key? key,}) : super(key: key);
  List<Map<dynamic, dynamic>> docs;
  final category;





  @override
  State<CategoryModels> createState() => _CategoryModelsState();
}

class _CategoryModelsState extends State<CategoryModels> {
  bool isFave = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category),),
      body:  ListView.builder(


        itemBuilder: (context, index) {

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ModelDetails(widget.docs[index]),));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),

              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(

                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${widget.docs[index]['image']}"),

                      radius: 40,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('  ${widget.docs[index]['name']}',style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('  Price: ${widget.docs[index]['price']}'),

                    ],
                  ),
                  Spacer(),



                ],
              ),
            ),
          );
        },
        itemCount:widget.docs.length,
      )

    );
  }
}
