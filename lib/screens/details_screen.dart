import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatelessWidget {
  final String newImage,newTitle,newData,author,description,content,source;

  const DetailsScreen({
    super.key,
    required this.newImage,
    required this.newTitle,
    required this.newData,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString); // Parse the date string
    return DateFormat('MMMM dd, yyyy').format(dateTime); // Format to "Month Day, Year"
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height*0.45,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight:Radius.circular(30),
                ),
                child: CachedNetworkImage(imageUrl: newImage,
                fit: BoxFit.cover,
                  placeholder: (context, url) => const SpinKitCircle(color: Colors.blue, size: 50,),
                  errorWidget: (context, url, error) => Image.asset('assets/NullPic.png',),),
          ),
          ),
          Container(
            height: height*0.6,
            margin: EdgeInsets.only(top: height*0.4),
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight:Radius.circular(40),
              ),
            ),
            child: ListView(
              children: [
                Text(newTitle,style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),),
                SizedBox(height: height*0.03),
                Row(
                  children: [
                    Expanded(child: Text(source,style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14,),)),
                    Text(formatDate(newData),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 14,),),
                  ],
                ),
                SizedBox(height: height*0.03),
                Text(description,style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17,),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
