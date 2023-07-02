import 'package:bib_nazionale_flutter/widgets/searchResult.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  String searchQuery = '';
  GoogleApi googleApi = GoogleApi();
  List<Book> bookList = [];
  bool showWelcomeSection = true;

  void updateSearchQuery(String query) async {
    setState(() {
      searchQuery = query;
    });

    if (query.isNotEmpty) {
      List<Book> books = await googleApi.getListOfBookByName(query);
      setState(() {
        bookList = books;
        showWelcomeSection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarSearch(onSearchChanged: updateSearchQuery),
      body: Column(
        children: [
          if (showWelcomeSection) Expanded(child: WelcomeSection()),
          Expanded(child: BookListView(books: bookList)),
        ],
      ),
    );
  }
}

class CustomAppBarSearch extends StatelessWidget
    implements PreferredSizeWidget {
  final Function(String) onSearchChanged;

  CustomAppBarSearch({required this.onSearchChanged});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      title: SearchView(onSearchChanged: onSearchChanged),
      automaticallyImplyLeading: false,
    );
  }
}

final Color customPurpleColor = const Color(0xFF6D77FB);

class SearchView extends StatefulWidget {
  final Function(String) onSearchChanged;

  SearchView({required this.onSearchChanged});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      widget.onSearchChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: customPurpleColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _textEditingController,
        onSubmitted: _handleSubmitted,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white, fontSize: 16),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () {
              _textEditingController.clear();
            },
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/best_home_library_apps.webp',
            height: 250,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Welcome to the app of\nBiblioteca Nazionale',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookListView extends StatelessWidget {
  final List<Book> books;

  BookListView({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: (books.length),
      itemBuilder: (context, index) {
        if (index < books.length-1) {
          Book book = books[index];
          return SearchResult(book: book);
        }
        else{
          return Container();
        }
      },
    );
  }
}

class GoogleApi {
  GoogleApi();

  Future<List<Book>> getListOfBookByName(String bookName) async {
    List<Book> books = await GoogleBooksApi().searchBooks(
      bookName,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
    return books;
  }

  Future<Book> getBookById(String idBook) async {
    Book books = await GoogleBooksApi().getBookById(idBook);
    return books;
  }
}