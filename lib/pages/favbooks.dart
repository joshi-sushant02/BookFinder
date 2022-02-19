import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fire2/database/dabase_helper.dart';

class BookData extends StatefulWidget {
  const BookData({Key? key}) : super(key: key);

  @override
  _BookDataState createState() => _BookDataState();
}

class _BookDataState extends State<BookData> {
  Future<List<dynamic>> getbooks() async {
    final List book = await DatabaseHelper.instance.getbook();
    print(book);
    return book;
  }

  Future delbook() async {
    final del = await DatabaseHelper.instance.deletebook();
    print(del);
    print("book deleted");
  }

  var COLORS = [
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFB892FF)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(40))),
              child: Stack(
                children: [
                  Positioned(
                      top: 50,
                      left: 0,
                      child: Container(
                        height: 65,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                      )),
                  Positioned(
                      top: 70,
                      left: 20,
                      child: Text(
                        "Saved Books",
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ))
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List>(
                future: getbooks(),
                builder: (_, AsyncSnapshot<List> bookdata) {
                  if (bookdata.hasData) {
                    print(bookdata.data!.length);
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: bookdata.data!.length,
                        itemBuilder: (context, index) {
                          return FavBooksList(
                            title: bookdata.data![index]['title'].toString(),
                            color: COLORS[Random().nextInt(5)],
                            author: bookdata.data![index]['author'].toString(),
                            function: () {
                              delbook();
                              getbooks();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookData()));
                              print("Delete book was pressed!");
                            },
                          );
                          // GestureDetector(
                          //   onTap: () {
                          //     delbook();
                          //     getbooks();
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => BookData()));
                          //     print("Delete book was pressed!");
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(bottom: 19),
                          //     height: 81,
                          //     width: MediaQuery.of(context).size.width - 50,
                          //     color: Colors.amber,
                          //     child: Row(
                          //       children: <Widget>[
                          //         Container(
                          //           height: 81,
                          //           width: 62,
                          //           decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(5),
                          //               image: DecorationImage(
                          //                 image: NetworkImage(bookdata.data![index]
                          //                         ['cover']
                          //                     .toString()),
                          //               ),
                          //               color: Colors.amber),
                          //         ),
                          //         SizedBox(
                          //           width: 21,
                          //         ),
                          //         Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: <Widget>[
                          //             Text(
                          //               bookdata.data![index]['title'].toString(),
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.w600,
                          //                   color: Colors.black),
                          //             ),
                          //             SizedBox(
                          //               height: 5,
                          //             ),
                          //             Text(
                          //               bookdata.data![index]['author'].toString(),
                          //               style: TextStyle(
                          //                   fontSize: 10,
                          //                   fontWeight: FontWeight.w400,
                          //                   color: Colors.grey),
                          //             ),
                          //             SizedBox(
                          //               height: 5,
                          //             ),
                          //             Text(
                          //               '\$' + "100",
                          //               style: TextStyle(
                          //                   fontSize: 14,
                          //                   fontWeight: FontWeight.w600,
                          //                   color: Colors.amberAccent),
                          //             )
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // );
                        });
                  } else {
                    return Container(
                      child: Text("empty"),
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

class FavBooksList extends StatefulWidget {
  Color color;
  String title;
  String author;
  VoidCallback function;
  FavBooksList({
    required this.color,
    required this.function,
    required this.title,
    required this.author,
  });

  @override
  _FavBooksListState createState() => _FavBooksListState();
}

class _FavBooksListState extends State<FavBooksList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color, widget.color],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(4, 4),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.label,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.author,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'avenir'),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (bool value) {},
                    value: true,
                    activeColor: Colors.white,
                  ),
                ],
              ),
              Text(
                'Mon-Fri',
                style: TextStyle(color: Colors.white, fontFamily: 'avenir'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title[20],
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'avenir',
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: widget.function),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GestureDetector(
//                           onTap: () {
//                             delbook();
//                             getbooks();
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => BookData()));
//                             print("Delete book was pressed!");
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 19),
//                             height: 81,
//                             width: MediaQuery.of(context).size.width - 50,
//                             color: Colors.amber,
//                             child: Row(
//                               children: <Widget>[
//                                 Container(
//                                   height: 81,
//                                   width: 62,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5),
//                                       image: DecorationImage(
//                                         image: NetworkImage(bookdata.data![index]
//                                                 ['cover']
//                                             .toString()),
//                                       ),
//                                       color: Colors.amber),
//                                 ),
//                                 SizedBox(
//                                   width: 21,
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       bookdata.data![index]['title'].toString(),
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       bookdata.data![index]['author'].toString(),
//                                       style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w400,
//                                           color: Colors.grey),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       '\$' + "100",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.amberAccent),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );


