import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/models/news_channel_headlines_model.dart';
import 'package:newsapp/view/categories_screen.dart';
import 'package:newsapp/view/news_detail_screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';
import '../animation.dart';
import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcNews,
  aryNews,
  independent,
  reuters,
  cnn,
  alJazeera,
  theverge
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd , yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('images/category_icon.png', height: 30, width: 30,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
          },
        ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.black,),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews == item) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews == item) {
                name = 'ary-news';
              }
              if (FilterList.cnn == item) {
                name = 'cnn';
              }
              if (FilterList.theverge == item) {
                name = 'the-verge';
              }

              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text('Ary News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.theverge,
                child: Text('The Verge'),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
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
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spinkit2,
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white.withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      height: height * 0.22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot.data!.articles![index].title.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  format.format(datetime),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return Column(
                      children: snapshot.data!.articles!.map((article) {
                        DateTime datetime = DateTime.parse(article.publishedAt.toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideUpPageRouteBuilder(
                                page: NewsDetailsScreen(
                                  newsImage: article.urlToImage.toString(),
                                  newsTitle: article.title.toString(),
                                  newsDate: article.publishedAt.toString(),
                                  author: article.author.toString(),
                                  description: article.description.toString(),
                                  content: article.content.toString(),
                                  source: article.source!.name.toString(),
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
                                    imageUrl: article.urlToImage.toString(),
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
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * 0.18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          article.title.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 3,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  article.source!.name.toString(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
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
                      }).toList(),
                    );
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

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
