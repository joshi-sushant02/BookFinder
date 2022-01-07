import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fire2/pages/auth_page.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find your Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Find your Book'),
          leading: IconButton(
            icon: Icon(Icons.ac_unit_outlined),
            onPressed: () async {
              await auth2.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ),
        body: Column(
          children: [
            TextField(
              controller: nameController,
              // keyboardType: TextInputType.emailAddress,
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
                // hintStyle: kHintTextStyle,
              ),
            ),
            Container(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    text = nameController.text.trim();
                    // fetchAlbum(text: text);
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
                      child: Text("No books avaible with such name"),
                    );
                  } else {
                    return ListView.separated(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, right: 8, bottom: 8),
                      itemCount: 5,
                      reverse: false,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.blue[500],
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 48,
                                height: 48,
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 40,
                                  height: 80,
                                  child: Image(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          "${snapshot.data!.items[index].volumeinfo.image.thumb}")),
                                ),
                              ),
                            ),
                            trailing: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            title: Text(
                              "${snapshot.data!.items[index].volumeinfo.title}",
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              "${snapshot.data!.items[index].kind}",
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () => null,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        thickness: 2,
                      ),
                    );
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

Future<Album> fetchAlbum({required String text}) async {
  final response = await http
      .get(Uri.parse("https://www.googleapis.com/books/v1/volumes?q=$text-"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.

    throw Exception('Failed to load album');
  }
}

class Album {
  final int id;
  final String title;
  final List<Item> items;

  Album({
    required this.items,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    try {
      var list = json['items'] as List;

      List<Item> itemList = list.map((i) => Item.fromJson(i)).toList();
      print(itemList.length);
      return Album(
        id: json['totalItems'],
        title: json['kind'],
        items: itemList,
      );
    } catch (e) {
      return Album(
        id: json['totalItems'],
        title: json['kind'],
        items: [],
      );
    }
  }
}

class Item {
  final String kind;

  final String etag;

  final VolumeInfo volumeinfo;

  Item({required this.kind, required this.etag, required this.volumeinfo});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        kind: json['kind'],
        etag: json['etag'],
        volumeinfo: VolumeInfo.fromJson(json['volumeInfo']));
  }
}

class VolumeInfo {
  final String title;

  final String printType;

  final ImageLinks image;

  VolumeInfo({
    required this.printType,
    required this.title,
    required this.image,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    print('GETTING DATA');
    //print(isbnList[1]);
    return VolumeInfo(
      title: json['title'],
      // publisher: json['publisher'],
      printType: json['printType'],
      image: ImageLinks.fromJson(
        json['imageLinks'],
      ),
    );
  }
}

class ImageLinks {
  final String thumb;

  ImageLinks({required this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(thumb: json['thumbnail']);
  }
}
