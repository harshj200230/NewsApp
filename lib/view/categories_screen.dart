import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/categories_news_model.dart';

import '../animation.dart';
import '../view_model/news_view_model.dart';
import 'home_screen.dart';
import 'news_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd , yyyy');

  String categoryName = 'General';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryName = categoriesList[index];
                      });
                    },
                    splashColor: Colors.transparent, // Set custom splash color
                    highlightColor: Colors.transparent, // Set custom highlight color
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: categoryName == categoriesList[index]
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: Text(
                              categoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          DateTime datetime =
                          DateTime.parse(snapshot.data!.articles![index]
                              .publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SlideUpPageRouteBuilder(
                                  page: NewsDetailsScreen(
                                    newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index]
                                          .urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                      width: width * 0.3,
                                      placeholder: (context, url) => Container(
                                        child: Center(
                                          child: SpinKitCircle(
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error_outline,
                                              color: Colors.red),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: height * 0.18,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 3,
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    maxLines: 3,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                    8), // Adjust the spacing between the two Text widgets
                                                Text(
                                                  format.format(datetime),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
