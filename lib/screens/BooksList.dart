import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fire2/database/book_model.dart';
import 'package:flutter_fire2/database/dabase_helper.dart';
import 'package:flutter_fire2/pages/bookDetails.dart';
import 'package:flutter_fire2/pages/book_details.dart';
import 'package:flutter_fire2/pages/favbooks.dart';
import 'package:flutter_fire2/screens/BooksApi.dart';
import 'package:flutter_fire2/utils/auth.dart';
import '../main.dart';
import 'dart:math';

class ShowBooks extends StatefulWidget {
  const ShowBooks({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ShowBooks> {
  late Future<Album> futureAlbum;
  final AuthenticationService auth2 =
      new AuthenticationService(FirebaseAuth.instance);

  final TextEditingController nameController = TextEditingController();
  String text = "google";

  var COLORS = [
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFDCE775),
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFDCE775),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your Book',
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: const Text('Find your Book'),
          leading: IconButton(
            tooltip: "LOGOUT",
            icon: Icon(Icons.logout_sharp),
            onPressed: () async {
              await auth2.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookData()));
              },
              icon: Icon(
                Icons.label_important,
                size: 30,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'LeonSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.book,
                  color: Colors.red,
                ),
                hintText: 'Enter your book',
              ),
            ),
            Container(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    text = nameController.text.trim();
                  });
                },
                child: Text("search"),
              ),
            ),
            Expanded(
                child: FutureBuilder<Album>(
              future: fetchAlbum(text: text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.items.length == 0) {
                    return Container(
                      child: Text("No items found by your search..."),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      primary: true,
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: (BuildContext content, int index) {
                        return AwesomeListItem(
                            bookid:
                                snapshot.data!.items[index].bookid.toString(),
                            title: snapshot.data!.items[index].volumeinfo.title
                                .toString(),
                            content: snapshot
                                .data!.items[index].volumeinfo.author
                                .toString(),
                            description: snapshot
                                .data!.items[index].volumeinfo.description
                                .toString(),
                            canonicalVolumeLink: snapshot.data!.items[index]
                                .volumeinfo.canonicalVolumeLink
                                .toString(),
                            function: () {
                              DatabaseHelper.instance.addbook(BookModel(
                                title:
                                    "${snapshot.data!.items[index].volumeinfo.title}",
                                author:
                                    "${snapshot.data!.items[index].volumeinfo.author}",
                                cover:
                                    "${snapshot.data!.items[index].volumeinfo.image.thumb}",
                                note:
                                    "${snapshot.data!.items[index].volumeinfo.description}",
                              ));
                              print("pressed");
                            },
                            color: COLORS[Random().nextInt(5)],
                            image: snapshot
                                .data!.items[index].volumeinfo.image.thumb
                                .toString());
                      },
                    );
                    // ListView.separated(
                    //   padding: const EdgeInsets.only(
                    //       top: 8, left: 8, right: 8, bottom: 8),
                    //   itemCount: 5,
                    //   reverse: false,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Container(
                    //       color: Colors.blue[500],
                    //       child: ListTile(
                    //           leading: GestureDetector(
                    //             onTap: () {},
                    //             child: Container(
                    //               width: 48,
                    //               height: 48,
                    //               padding: EdgeInsets.symmetric(vertical: 4.0),
                    //               alignment: Alignment.center,
                    //               child: Container(
                    //                 width: 40,
                    //                 height: 80,
                    //                 child: Image(
                    //                     fit: BoxFit.fill,
                    //                     image: NetworkImage(
                    //                         "${snapshot.data!.items[index].volumeinfo.image.thumb}")),
                    //               ),
                    //             ),
                    //           ),
                    //           trailing: Icon(
                    //             Icons.more_vert,
                    //             color: Colors.white,
                    //           ),
                    //           title: Text(
                    //             "${snapshot.data!.items[index].volumeinfo.title}",
                    //             style: TextStyle(color: Colors.black),
                    //           ),
                    //           subtitle: Text(
                    //             "${snapshot.data!.items[index].kind}",
                    //             style: TextStyle(color: Colors.black),
                    //           ),
                    //           onTap: () {
                    //             // BookModel(title:"${snapshot.data!.items[index].volumeinfo.title}" );

                    //             DatabaseHelper.instance.addbook(BookModel(
                    //                 title:
                    //                     "${snapshot.data!.items[index].volumeinfo.title}"));
                    //           }),
                    //     );
                    //   },
                    //   separatorBuilder: (BuildContext context, int index) =>
                    //       Divider(
                    //     thickness: 2,
                    //   ),
                    // );

                  }
                }

                // By default, show a loading spinner.
                return Container(
                    height: 60.0,
                    child: new Center(child: new CircularProgressIndicator()));
              },
            ))
          ],
        ),
      ),
    );
  }
}

class AwesomeListItem extends StatefulWidget {
  String title;
  String bookid;
  String content;
  String description;
  Color color;
  String image;
  String canonicalVolumeLink;
  VoidCallback function;

  AwesomeListItem(
      {required this.title,
      required this.description,
      required this.content,
      required this.color,
      required this.bookid,
      required this.function,
      required this.canonicalVolumeLink,
      required this.image});

  @override
  _AwesomeListItemState createState() => _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 10.0, height: 190.0, color: widget.color),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(50.0, 0.0),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: widget.color,
                ),
              ),
              Transform.translate(
                offset: Offset(10.0, 20.0),
                child: Card(
                  elevation: 20.0,
                  child: GestureDetector(
                    // onTap: widget.function,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectedBookScreen(
                                  cover: widget.image,
                                  bookid: widget.bookid,
                                  title: widget.title,
                                  function: widget.function,
                                  author: widget.content,
                                  description: widget.description,
                                  canonicalVolumeLink:
                                      widget.canonicalVolumeLink)));
                    },
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 10.0,
                              color: Colors.white,
                              style: BorderStyle.solid),
                          image: DecorationImage(
                            image: NetworkImage(widget.image),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
