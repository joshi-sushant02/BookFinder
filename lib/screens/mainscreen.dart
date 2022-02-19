
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_fire2/pages/auth_page.dart';
// import 'package:http/http.dart' as http;

// import '../main.dart';
// import './googleapi.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   List<Book> _items = [];
//   final subject = new PublishSubject<String>();
//   bool _isLoading = false;
//   // late final T body;
//   @override
//   void initState() {
//     super.initState();
//     subject.stream
//         .debounce((_) => TimerStream(true, Duration(seconds: 1)))
//         .listen(_textChanged);
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.access_alarm),
//           onPressed: () => Navigator.push(
//               context, MaterialPageRoute(builder: (context) => MyApp())),
//         ),
//         title: Text("Book_finder"),
//         centerTitle: true,
//         actions: [],
//       ),
//       body: Column(
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               hintText: 'Choose a book',
//             ),
//             onChanged: (string) => (subject.add(string)),
//           ),
//           Expanded(
//               child: ListView.builder(
//                   itemCount: _items.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       child: Row(
//                         children: <Widget>[
//                           _items[index].url != null
//                               ? new Image.network(_items[index].url)
//                               : new Container(),
//                           // if(_items[index].url!=null)
//                           // {
//                           //    Image.network(_items[index].url);

//                           // }
//                           // else{
//                           // Conatiner();
//                           // }
//                           Flexible(
//                             child: new Text(_items[index].title, maxLines: 10),
//                           ),
//                         ],
//                       ),
//                     );
//                   }))
//         ],
//       ),
//     );
//   }

//   void _textChanged(String text) {
//     if (text.isEmpty) {
//       setState(() {
//         _isLoading = false;
//       });
//       _clearList();
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//     });
//     _clearList();
//     http
//         .get(Uri.parse("https://www.googleapis.com/books/v1/volumes?q=$text"))
//         .then((response) => response.body)
//         .then(JSON.Decode)
//         .then((map) => map["items"])
//         .then((list) {
//           list.forEach(_addBook);
//         })
//         .catchError(_onError)
//         .then((e) {
//           setState(() {
//             _isLoading = false;
//           });
//         });
//   }

//   void _onError(dynamic d) {
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _clearList() {
//     setState(() {
//       _items.clear();
//     });
//   }

//   void _addBook(dynamic book) {
//     setState(() {
//       _items.add(new Book(book["volumeInfo"]["title"],
//           book["volumeInfo"]["imageLinks"]["smallThumbnail"]));
//     });
//   }
// }

// class Book {
//   String title;
//   String url;
//   Book(this.title, this.url);
// }


