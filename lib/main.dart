import 'dart:math';

import 'package:flutter/material.dart';

import 'data.dart';

void main() => runApp(MyApp());

var bookAspectRatio = 10.0 / 14.0;
var widgetAspectRatio = bookAspectRatio * 1.2;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentPage = double.parse("${bookImage.length - 1}") ;

  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: bookImage.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
      backgroundColor: Color(0xFFF1EBDC),
      body: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset("images/logo.png", scale: 5),
                    Icon(Icons.search),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Çok Satanlar",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontFamily: "Montserrat",
                      letterSpacing: 1.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20.0,
                ),
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF23D59).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text("%20 İndirim",
                        style: TextStyle(color: Colors.white))),
              ),
              Stack(
                children: <Widget>[
                  BookCardWidget(currentPage),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: bookImage.length,
                      controller: controller,
                      reverse: false,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("Kategoriler",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontFamily: "Montserrat",
                      letterSpacing: 1.0,
                    )),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: categoryImage.map((index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, left: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(index), fit: BoxFit.cover),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${categoryName[categoryImage.indexOf(index)]}",
                          style:
                              TextStyle(fontWeight: FontWeight.bold,fontSize: 16, fontFamily: "Montserrat"),
                        ),
                      ),
                    ),
                  );
                }).toList()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BookCardWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  BookCardWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var safeWidth = width;
        var safeHeight = height;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * bookAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < bookImage.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;
          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.ltr,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: bookAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(bookImage[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF2395E8),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Satın Al",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
