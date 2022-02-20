import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:google_fonts/google_fonts.dart';

class SelectedBookScreen extends StatelessWidget {
  String title;
  String bookid;
  String cover;
  String description;
  String author;
  String canonicalVolumeLink;
  VoidCallback function;
  SelectedBookScreen({
    required this.cover,
    required this.bookid,
    required this.title,
    required this.function,
    required this.description,
    required this.canonicalVolumeLink,
    required this.author,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
        height: 49,
        color: Colors.transparent,
        child: FlatButton(
          color: Colors.brown,
          onPressed: function,
          child: Text(
            'Click to Save',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: Container(
                  color: Colors.deepOrange[200],
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          // margin: EdgeInsets.only(bottom: 62),
                          // width: 172,
                          // height: 225,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              repeat: ImageRepeat.repeat,
                              image: NetworkImage(cover),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 62),
                          width: 185,
                          height: 238,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(cover),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 70),
                          width: 170,
                          height: 220,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color(0xFFbebebe),
                                // color: Colors.black,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(cover),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 25),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 27,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 25),
                  child: Text(
                    "$author",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 25),
                  child: InkWell(
                      child: new Text(
                        'Buy Now 👈🏻',
                        style: TextStyle(
                          fontFamily: 'LeonSans',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                          letterSpacing: 1.5,
                          height: 2,
                        ),
                      ),
                      onTap: () => launch('$canonicalVolumeLink')),
                ),
                Container(
                  height: 28,
                  margin: EdgeInsets.only(top: 23, bottom: 36),
                  padding: EdgeInsets.only(left: 25),
                  child: DefaultTabController(
                    length: 3,
                    child: TabBar(
                        labelPadding: EdgeInsets.all(0),
                        indicatorPadding: EdgeInsets.all(0),
                        isScrollable: true,
                        labelColor: Colors.grey,
                        unselectedLabelColor: Colors.black,
                        labelStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        indicator: RoundedRectangleTabIndicator(
                            weight: 2, width: 50, color: Colors.black),
                        tabs: [
                          Tab(
                            child: Container(
                              margin: EdgeInsets.only(right: 39),
                              child: Text('Description'),
                            ),
                          ),
                          Tab(
                            child: InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(right: 39),
                                  child: Text('Preview'),
                                ),
                                onTap: () => launch(
                                    'https://books.google.co.in/books?id=$bookid&hl=&cd=1&source=gbs_api')),
                          ),
                          Tab(
                            child: InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(right: 39),
                                  child: Text('Similar'),
                                ),
                                onTap: () => launch(
                                    'https://www.google.co.in/search?tbm=bks&hl=en&q=$title')),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: Text(
                    "$description",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      letterSpacing: 1.5,
                      height: 2,
                    ),
                  ),
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedRectangleTabIndicator extends Decoration {
  final BoxPainter? _painter;

  RoundedRectangleTabIndicator(
      {required Color? color, required double? weight, required double? width})
      : _painter = _RRectanglePainterColor(color!, weight!, width!);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter!;
    // throw UnimplementedError();
  }
}

class _RRectanglePainterColor extends BoxPainter {
  final Paint _paint;
  final double weight;
  final double width;

  _RRectanglePainterColor(Color color, this.weight, this.width)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset customOffset = offset + Offset(0, cfg.size!.height - weight);

    //Custom Rectangle
    Rect myRect = customOffset & Size(width, weight);

    // Custom Rounded Rectangle
    RRect myRRect = RRect.fromRectXY(myRect, weight, weight);

    canvas.drawRRect(myRRect, _paint);
  }
}
