import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String text = "google";
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
      print(e);
      return Album(
        id: json['totalItems'],
        title: json['kind'],
        items: [],
      );
    }
  }
}

class Item {
  final String bookid;

  final String etag;

  final VolumeInfo volumeinfo;

  Item({required this.bookid, required this.etag, required this.volumeinfo});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        bookid: json['id'],
        etag: json['etag'],
        volumeinfo: VolumeInfo.fromJson(json['volumeInfo']));
  }
}

class VolumeInfo {
  final String title;

  final String canonicalVolumeLink;
  final String author;
  final String description;
  final ImageLinks image;

  VolumeInfo({
    required this.canonicalVolumeLink,
    required this.title,
    required this.image,
    required this.author,
    required this.description,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    print('GETTING DATA');

    // print(isbnList[1]);
    // print(isbnList[1]);
    try {
      return VolumeInfo(
        title: json['title'],
        author: json['authors'][0],
        description: json['description'],
        canonicalVolumeLink: json['canonicalVolumeLink'],
        image: ImageLinks.fromJson(
          json['imageLinks'],
        ),
      );
    } catch (e) {
      print(e);
      return VolumeInfo(
          title: json['title'],
          author: "Author-name unavaiable",
          description:
              "Whether reading the short or long description, both need to be full of what readers want: intrigue. It’s up to you to get readers interested in what you have to say, and while we know you could probably write pages upon pages explaining what your book is about, your space and reader attention span are limited. When creating book metadata, you want to make sure you provide the information needed to help buyers, including consumers, booksellers, and librarians, understand what they're about to purchase and whether they want to. Having the right information in place determines not only whether you attract the attention of your audience, but whether you attract the right audience. ",
          canonicalVolumeLink:
              "https://books.google.co.in/?hl=en&tab=pp&authuser=0",
          image: ImageLinks(
              thumb:
                  "http://books.google.com/books/content?id=4yIEwQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"));
    }
  }
}

class ImageLinks {
  final String thumb;

  ImageLinks({required this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    print('GETTING Image');
    try {
      return ImageLinks(thumb: json['thumbnail']);
    } catch (e) {
      return ImageLinks(
          thumb:
              "http://books.google.com/books/content?id=4yIEwQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api");
    }
  }
}
