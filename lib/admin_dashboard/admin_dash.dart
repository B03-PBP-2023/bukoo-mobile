import 'package:flutter/material.dart';
import 'package:bukoo/admin_dashboard/detail_admin.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';

void main() => runApp(const AdminDash());

class AdminDash extends StatelessWidget {
  const AdminDash({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(); // Kembalikan langsung DashboardPage
  }
}

class DashboardPage extends StatelessWidget {
  final List<Book> books = [
    Book(
      number: 1,
      title: 'Book 1',
      publisher: 'Publisher 1',
      genre: 'Genre 1',
      status: 'Verified',
      description: 'bagus',
      language: 'Bahasa',
      isbn: '0000000',
      numberOfPages: 266,
      publishDate: '19/02/2004',
    ),
    // Tambahkan lebih banyak buku di sini
  ];

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nomor')),
            DataColumn(label: Text('Judul Buku')),
            DataColumn(label: Text('Penerbit')),
            DataColumn(label: Text('Genre')),
            DataColumn(label: Text('Detail')),
            DataColumn(label: Text('Status')),
          ],
          rows: books
              .map((book) => DataRow(cells: [
                    DataCell(Text(book.number.toString())),
                    DataCell(Text(book.title)),
                    DataCell(Text(book.publisher)),
                    DataCell(Text(book.genre)),
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Menyelaraskan secara vertikal
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Menyelaraskan secara horizontal
                      children: [
                        TextButton(
                          onPressed: () => _showBookDetail(book, context),
                          child: const Text('Detail'),
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
      MaterialPageRoute(builder: (context) => DetailAdminPage(book: book)),
    );
  }
}

Widget buildStatusWidget(String status) {
  if (status == 'Verified') {
    return SizedBox(
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
                color: const Color(0x7072D535),
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
  int number;
  String title;
  String publisher;
  String genre;
  String status;
  String description;
  String language;
  String isbn;
  int numberOfPages;
  String publishDate;

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
}
