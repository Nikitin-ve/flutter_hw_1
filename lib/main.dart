import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

const NewsApiURL = 'https://newsdata.io/api/1/news?apikey=pub_39506216359bff03547de10463a49d27c4f95';

String Give_Text(data, int ind, String header) {
  return data['results'][ind][header] == null ?
  '${header} отсутствует' : data['results'][ind][header];
}

class SingleChildScrollViewNews extends StatefulWidget {
  final data;

  SingleChildScrollViewNews({
    this.data,
    super.key,
  });

  @override
  State<SingleChildScrollViewNews> createState() => _SingleChildScrollViewNewsState();
}

class _SingleChildScrollViewNewsState extends State<SingleChildScrollViewNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.data['results'].length,
              itemBuilder: (context, index) => Headline(ind: index, data: widget.data,),
            ),
          ),
        ],
      ),
    );
  }
}

class Headline extends StatefulWidget {
  final ind;
  final data;

  Headline({
    this.data,
    this.ind,
    super.key,
  });

  @override
  State<Headline> createState() => _HeadlineState();
}

class _HeadlineState extends State<Headline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 100)),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(15)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                // Change your radius here
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(image: NetworkImage(widget.data['results'][widget.ind]['image_url'] == null ?
                  'https://www.atomproperty.ru/upload/iblock/e61/e6137c9cc7835eb8a7fed0eb8fc71217.jpg' :
                  widget.data['results'][widget.ind]['image_url']), fit: BoxFit.fitWidth),
                ),
              ),
              SizedBox(width: 15,),
              Flexible(
                child: Text(Give_Text(widget.data, widget.ind, 'description'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OnlyNews(data: widget.data, ind: widget.ind,)));
          },
        )
      ],
    );
  }
}

void main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  final dio = Dio();
  final response = await dio.get(NewsApiURL);
  runApp(
    MaterialApp(
      home: News(data: response.data, ),
    ),
  );
}

class News extends StatefulWidget {
  final data;

  News({
    this.data,
    super.key,
  });

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollViewNews(data: widget.data, ),
      ),
    );
  }
}

class OnlyNews extends StatefulWidget {
  final ind;
  final data;

  OnlyNews({
    this.data,
    this.ind,
    super.key,
  });

  @override
  State<OnlyNews> createState() => _OnlyNewsState();
}

class _OnlyNewsState extends State<OnlyNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollViewOnlyNews(ind: widget.ind, data: widget.data,),
    );
  }
}

class SingleChildScrollViewOnlyNews extends StatefulWidget {
  final data;
  final ind;

  SingleChildScrollViewOnlyNews({
    this.ind,
    this.data,
    super.key,
  });

  @override
  State<SingleChildScrollViewOnlyNews> createState() => _SingleChildScrollViewOnlyNewsState();
}

class _SingleChildScrollViewOnlyNewsState extends State<SingleChildScrollViewOnlyNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your news',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0) //                 <--- border radius here
                      ),
                    ),
                    child: Flexible(
                      child: Text(
                        Give_Text(widget.data, widget.ind, 'title'),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.center,
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(image: NetworkImage(widget.data['results'][widget.ind]['image_url'] == null ?
                      'https://www.atomproperty.ru/upload/iblock/e61/e6137c9cc7835eb8a7fed0eb8fc71217.jpg' :
                      widget.data['results'][widget.ind]['image_url']), fit: BoxFit.fitWidth),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0) //                 <--- border radius here
                      ),
                    ),
                    child: Flexible(
                      child: Text(
                        Give_Text(widget.data, widget.ind, 'description'),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            // Change your radius here
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Flexible(
                        child: Text(
                          'Перейти к источнику',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () => _launchURL(Give_Text(widget.data, widget.ind, 'link'))
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}