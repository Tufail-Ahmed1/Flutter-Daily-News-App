import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/latest_news_model.dart';
import 'package:news_app/screens/categories_screen.dart';
import 'package:news_app/services/api_services.dart';
import 'package:intl/intl.dart';

import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 enum ChannelMenu {bbc,aryNews, alJazeera,abc }

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();
  late Future<LatestNewsModel> latestNewsFuture;
  late Future<CategoriesNewsModel> categoryFuture;

  ChannelMenu? selectedMenu;
  String name='bbc-news';

  @override
  void initState() {
    super.initState();
   fetchNews();
  }
  void fetchNews() {
    setState(() {
      latestNewsFuture = apiServices.getLatestNewsModel(name);
      categoryFuture=apiServices.getCatogoriesModel('business');
    });
  }
  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString); // Parse the date string
    return DateFormat('MMMM dd, yyyy').format(dateTime); // Format to "Month Day, Year"
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Daily News',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen(),));
              },
              icon: const Icon(Icons.menu_book),
          ),
          actions: [
             PopupMenuButton<ChannelMenu>(
              initialValue: selectedMenu,
                onSelected: (value) {
                setState(() {
                  selectedMenu=value;

                  if(value == ChannelMenu.aryNews)
                    {
                      name='ary-news';
                    }
                  else if(value==ChannelMenu.bbc)
                    {
                      name='bbc-news';
                    }
                  else if(value==ChannelMenu.alJazeera)
                    {
                      name='al-jazeera-english';
                    }
                  else if(value==ChannelMenu.abc)
                    {
                      name='abc-news';
                    }
                  fetchNews();
                });
                },
                itemBuilder: (context) => <PopupMenuEntry<ChannelMenu>> [
                  const PopupMenuItem(
                    value: ChannelMenu.aryNews,
                    child: Text('Ary News'),
                  ),
                  const PopupMenuItem(
                    value: ChannelMenu.bbc,
                      child: Text('BBC News'),
                  ),
                  const PopupMenuItem(
                      value: ChannelMenu.alJazeera,
                      child: Text('Al Jazeera News')),
                  const PopupMenuItem(
                      value: ChannelMenu.abc,
                      child: Text('Abc News')),
                ],
            ),
          ],
        ),
        body: ListView(
          children: [
             const Padding(
              padding: EdgeInsets.only(top: 8,left: 12,bottom: 4),
              child: Text('Headlines News',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder(
                  future: latestNewsFuture,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: data!.articles.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailsScreen(
                                newImage: snapshot.data!.articles[index].urlToImage.toString(),
                                content: snapshot.data!.articles[index].content.toString(),
                                author: snapshot.data!.articles[index].author.toString(),
                                description: snapshot.data!.articles[index].description.toString(),
                                newData: snapshot.data!.articles[index].publishedAt.toString(),
                                newTitle: snapshot.data!.articles[index].title.toString(),
                                source: snapshot.data!.articles[index].source.name.toString(),

                              )));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.7,
                                    width: width * 0.9,
                                    padding: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: data.articles[index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => spin,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error_outline,
                                                color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: height * .22,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Text(
                                                data.articles[index].title,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: width * 0.7,
                                              child: FittedBox(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(formatDate(data.articles[index].publishedAt.toString()),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      data.articles[index].source.name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
             Padding(
              padding: const EdgeInsets.only(top: 5,left: 12,bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Latest News',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 23),),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const CategoriesScreen()));
                    },
                    child: const Text('Show More',
                      style: TextStyle(color: Colors.red,fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
                ],
              ),
            ),
            FutureBuilder(
                future: categoryFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: data!.articles.length,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap:() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(
                              newImage: snapshot.data!.articles[index].urlToImage.toString(),
                              content: snapshot.data!.articles[index].content.toString(),
                              author: snapshot.data!.articles[index].author.toString(),
                              description: snapshot.data!.articles[index].description.toString(),
                              newData: snapshot.data!.articles[index].publishedAt.toString(),
                              newTitle: snapshot.data!.articles[index].title.toString(),
                              source: snapshot.data!.articles[index].source.name.toString(),
                            ),));
                          },
                          child: Row(
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
                                        errorWidget: (context, url, error) => Image.asset('assets/NullPic.png',
                                          fit: BoxFit.cover,
                                        ),
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
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(formatDate(data.articles[index].publishedAt.toString()),
                                                      style: const TextStyle(color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                      ),

                                                    ),
                                                    Flexible(
                                                      child: Text(data.articles[index].source.name.toString(),
                                                        style: const TextStyle(color: Colors.black,
                                                          fontSize: 14,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                          ),
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
          ],
        ),
    );
  }
}

var spin = const SpinKitCircle(
  color: Colors.blue,
  size: 50,
);
