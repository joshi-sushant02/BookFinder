import 'package:books_finder/books_finder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire2/main.dart';
import 'package:flutter_fire2/pages/auth_page.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({Key? key}) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  var Book_name;
  var Book_name1;
  var Book_author;
  Future function(namee) async {
    final books = await queryBooks(
      namee,
      maxResults: 1,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
      reschemeImageLinks: true,
    );

    books.forEach((book) {
      setState(() {
        Book_name1 = book.info.title;
        Book_author = book.info.authors;
      });
    });
  }

  final AuthenticationService auth2 =
      new AuthenticationService(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () {
            auth2.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
        title: Text("book"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    Book_name = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Book",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0)))),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    child: TextButton(
                        child: Text("okay"),
                        onPressed: () {
                          function(Book_name);
                        }))),
            Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Text("maybe you are looking for this"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text("$Book_name1"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text("$Book_author"),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
