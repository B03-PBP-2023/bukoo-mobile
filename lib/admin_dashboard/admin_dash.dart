import 'package:flutter/material.dart';
import 'package:bukoo/admin_dashboard/detail_admin.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

// void main() => runApp(AdminDash());

class AdminDash extends StatefulWidget {
  final List<Map<String, dynamic>> submittedBooks; // Tambahkan parameter ini

  AdminDash({Key? key, this.submittedBooks = const []}) : super(key: key);
  // AdminDash({super.key, required this.submittedBooks});
  static const routeName = '/admin-dash';

  @override
  State<AdminDash> createState() => _DashboardPage();
}

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book book) {
    int index = _books.indexWhere((b) => b.isbn == book.isbn);
    if (index != -1) {
      _books[index] = book;
      notifyListeners();
    }
  }
}


class _DashboardPage extends State<AdminDash>{
  List<Book> books = [];
   @override
  void initState() {
    super.initState();
    books.addAll(widget.submittedBooks.map((bookData) => Book.fromJson(bookData)));// Tambahkan data yang dikirim dari BookSubmissionPage
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600; // contoh breakpoint
    List<Book> books = Provider.of<BookProvider>(context).books;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nomor')),
            DataColumn(label: Text('Judul Buku')),
            DataColumn(label: Text('Detail')),
            DataColumn(label: Text('Status')),
          ],
          rows: books
              .map((book) => DataRow(cells: [
                    DataCell(Text(book.number.toString())),
                    DataCell(Text(book.title)),
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Menyelaraskan secara vertikal
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Menyelaraskan secara horizontal
                      children: [
                        TextButton(
                          onPressed: () => _showBookDetail(book, context),
                          child: Text('Detail'),
                        ),
                      ],
                    )),
                    DataCell(buildStatusWidget(book.status)),
                  ]))
              .toList(),
        ),
      ),
    );
  }

  void _showBookDetail(Book book, BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DetailAdminPage(book: book, submittedBooks: books),
    ),
  );
}

}

Widget buildStatusWidget(String status) {
  if (status == 'Verified') {
    return Container(
      width: 65,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 65,
              height: 30,
              decoration: ShapeDecoration(
                color: Color(0x7072D535),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const Positioned.fill(
            // Menggunakan Positioned.fill
            child: Align(
              // Menggunakan Align untuk pusatkan teks
              alignment: Alignment.center,
              child: Text(
                'Verified',
                style: TextStyle(
                  color: Color(0xFF24460F),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    // Kode untuk status lain
    return Text(status);
  }
}

class Book {
  final int number;
  final String title;
  final String publisher;
  final String genre;
  final String status;
  final String description;
  final String language;
  final String isbn;
  final int numberOfPages;
  final String publishDate;

  Book({
    required this.number,
    required this.title,
    required this.publisher,
    required this.genre,
    required this.status,
    required this.description,
    required this.language,
    required this.isbn,
    required this.numberOfPages,
    required this.publishDate,
  });

  // Konstruktor `fromJson`
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      number: json['number'],
      title: json['title'],
      publisher: json['publisher'],
      genre: json['genre'],
      status: json['status'],
      description: json['description'],
      language: json['language'],
      isbn: json['isbn'],
      numberOfPages: json['numberOfPages'],
      publishDate: json['publishDate'],
    );
  }

  // Metode `toJson`
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'publisher': publisher,
      'genre': genre,
      'status': status,
      'description': description,
      'language': language,
      'isbn': isbn,
      'numberOfPages': numberOfPages,
      'publishDate': publishDate,
    };
  }
}

