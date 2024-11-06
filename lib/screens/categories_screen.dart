import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/services/api_services.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<CategoriesNewsModel> categoryFuture;

  ApiServices apiServices=ApiServices();
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData(){
    setState(() {
      categoryFuture=apiServices.getCatogoriesModel(categoryName);
    });
  }
  String categoryName='general';

  List<String> categoryList =[
    'General',
    'Entertainment',
    'Health',
    'Business',
    'Science',
    'Sports',
    'Technology'

    ];

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString); 
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
      ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: categoryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      categoryName=categoryList[index];
                      fetchData();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: categoryName==categoryList[index] ? Colors.blue.shade800:Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(categoryList[index].toString()),
                        ),
                      ),
                    ),

                  ),
                );

                },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: categoryFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: data!.articles.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: data.articles[index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height:height*0.20,
                                      width: width*0.3,
                                      placeholder: (context, url) => spin,
                                      errorWidget: (context, url, error) => Image.asset('assets/NullPic.png'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height*0.18,
                                    width: width*0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            Text(data.articles[index].title.toString(),
                                              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(formatDate(data.articles[index].publishedAt.toString()),
                                                  style: const TextStyle(color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Flexible(
                                                  child: Text(data.articles[index].source.name.toString(),
                                                    style: const TextStyle(color: Colors.black,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else {
                    return Container(
                      child: spin,
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}


var spin = const SpinKitCircle(
  color: Colors.blue,
  size: 50,
);
