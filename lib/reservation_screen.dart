import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCode extends StatefulWidget {
  GenerateQrCode({Key? key,required this.data}) : super(key: key);
  final String  data;
  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservation"),),
      body:  Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              QrImage(data:widget.data,
                size: 200,
                backgroundColor: Colors.white,
              ),
             Text("Save this Qr Code!",style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
