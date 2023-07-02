import 'package:flutter/material.dart';

import '../models/DatabaseProvider.dart';
import '../models/dbbooks.dart';
import 'bookInfo.dart';

final Color customPurpleColor = const Color(0xFF6D77FB);

class BookDeletePage extends StatelessWidget {
  final DBBook book;

  const BookDeletePage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customPurpleColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BookHeader(
                image: book.image,
                title: book.title,
                authors: book.authors,
              ),
              SizedBox(height: 16.0),
              BookInfo(description: book.description),
              SizedBox(height: 16.0),
              DeleteBookButton(book: book),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          image,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 16.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          authors,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class BookInfo extends StatelessWidget {
  final String description;

  const BookInfo({required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(fontSize: 16.0),
    );
  }
}

class DeleteBookButton extends StatelessWidget {
  final DBBook book;

  const DeleteBookButton({required this.book});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Are you sure to remove the book from the booked list?'),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    _deleteBook(context);
                  },
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: customPurpleColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Text(
          'Delete Book',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  Future<void> _deleteBook(BuildContext context) async {
    await DatabaseProvider().deleteBook(book.id!);

    Navigator.of(context).pop(); // Chiude lo screen di eliminazione del libro
    Navigator.of(context).pop(); // Torna alla schermata precedente (MyBooks)
  }
}

