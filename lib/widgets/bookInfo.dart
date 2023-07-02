import 'package:bib_nazionale_flutter/widgets/bookList.dart';
import 'package:flutter/material.dart';

import '../models/DatabaseProvider.dart';
import '../models/dbbooks.dart';

final Color customPurpleColor = const Color(0xFF6D77FB);

class BookDetailsPage extends StatefulWidget {
  final String title;
  final String authors;
  final String description;
  final String image;

  const BookDetailsPage({
    required this.title,
    required this.authors,
    required this.description,
    required this.image,
  });

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  DatabaseProvider _databaseProvider = DatabaseProvider();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Resto del codice
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BookHeader(
                image: widget.image,
                title: widget.title,
                authors: widget.authors,
              ),
              SizedBox(height: 16.0),
              BookInfo(description: widget.description),
              SizedBox(height: 16.0),
              RequestBookButton(
                onPressed: () async {
                  DBBook book = DBBook(
                    title: widget.title,
                    authors: widget.authors,
                    image: widget.image,
                    description: widget.description,
                  );
                  try {
                    await _databaseProvider.addBook(book);
                    setState(() {
                      _message = 'Book successfully requested!';
                    });
                  } catch (e) {
                    setState(() {
                      _message = 'Failed to request book. Please try again.';
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _message.startsWith('Failed') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookHeader extends StatelessWidget {
  final String image;
  final String title;
  final String authors;

  const BookHeader({
    required this.image,
    required this.title,
    required this.authors,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              image,
              width: 200.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            Center(
              child: Text(
                authors,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookInfo extends StatefulWidget {
  final String description;

  const BookInfo({required this.description});

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'About the Book',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final TextSpan text = TextSpan(
                  text: widget.description,
                  style: DefaultTextStyle.of(context).style,
                );
                final TextPainter textPainter = TextPainter(
                  textAlign: TextAlign.right,
                  text: text,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout(maxWidth: constraints.maxWidth);
                final int actualLines = textPainter.computeLineMetrics().length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    actualLines > 5
                        ? Text(
                      widget.description,
                      maxLines: isExpanded ? 5 : null,
                      overflow: isExpanded
                          ? TextOverflow.ellipsis
                          : TextOverflow.visible,
                    )
                        : Text(widget.description),
                    actualLines > 5
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? 'Read more' : 'Read less',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: customPurpleColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                        : Container(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RequestBookButton extends StatelessWidget {
  final VoidCallback onPressed;

  RequestBookButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: customPurpleColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Text(
          'Request Book',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class CustomMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.grey,
      child: Center(
        child: Text(
          'Map View',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}

void main() {
  runApp(BookDetailsApp());
}

class BookDetailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookDetailsPage(
        title: 'Titolo del libro',
        authors: 'Nome degli autori',
        description: 'Descrizione del libro',
        image: 'a',
      ),
    );
  }
}
