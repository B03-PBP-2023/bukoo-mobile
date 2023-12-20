import 'package:bukoo/admin_dashboard/models/book_submission.dart';
import 'package:bukoo/admin_dashboard/models/dashboard_statisics.dart';
import 'package:bukoo/admin_dashboard/widgets/statistic_card.dart';
import 'package:bukoo/core/config.dart';
import 'package:flutter/material.dart';
import 'package:bukoo/admin_dashboard/detail_admin.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AdminDash extends StatefulWidget {
  const AdminDash({super.key});
  static const routeName = '/admin-dash';

  @override
  State<AdminDash> createState() => _DashboardPage();
}

class _DashboardPage extends State<AdminDash> {
  List<BookSubmission> _bookSubmissions = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    refreshBookSubmission();
  }

  Future<void> refreshBookSubmission() async {
    setState(() {
      _isLoading = true;
      _bookSubmissions = [];
    });
    try {
      List<BookSubmission> bookSubmissionList = await fetchBookSubmission();
      setState(() {
        _bookSubmissions = bookSubmissionList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<BookSubmission>> fetchBookSubmission() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final response = await request.get('$BASE_URL/api/admin-dashboard/json/');
    List<BookSubmission> bookSubmissionList = response
        .map<BookSubmission>((json) => BookSubmission.fromJson(json))
        .toList();
    return bookSubmissionList;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600; // contoh breakpoint

    return RefreshIndicator(
      onRefresh: refreshBookSubmission,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
            title: const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0))),
        drawer: const LeftDrawer(),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Builder(builder: (context) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_error != null) {
              return Center(child: Text(_error!));
            }
            if (_bookSubmissions.isEmpty) {
              return const Center(child: Text('Tidak ada pengajuan buku.'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      crossAxisCount: 2,
                      children: _getDashboardStatistics(_bookSubmissions)
                          .map((data) => StatisticCard(data: data))
                          .toList(),
                    ),
                  ),
                  DataTable(
                    columnSpacing: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    columns: const [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Judul Buku')),
                      DataColumn(label: Text('Detail')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: _bookSubmissions.asMap().entries.map((entry) {
                      int number = entry.key + 1;
                      BookSubmission submission = entry.value;
                      return DataRow(cells: [
                        DataCell(Text(number.toString())),
                        DataCell(Text(submission.book.title!)),
                        DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Menyelaraskan secara vertikal
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Menyelaraskan secara horizontal
                          children: [
                            TextButton(
                              onPressed: () =>
                                  _showBookDetail(submission, context),
                              child: const Text('Detail'),
                            ),
                          ],
                        )),
                        DataCell(buildStatusWidget(submission.status)),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showBookDetail(BookSubmission bookSubmission, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailAdminPage(bookSubmission: bookSubmission),
      ),
    );
  }

  List<DashboardStatistics> _getDashboardStatistics(
      List<BookSubmission> bookSubmissions) {
    return [
      DashboardStatistics(
        title: 'Book Submission',
        value: bookSubmissions.length,
        color: const Color(0xFF3562D6),
        icon: Icons.bar_chart_rounded,
      ),
      DashboardStatistics(
        title: 'Pending',
        value: bookSubmissions
            .where((element) => element.status == 'pending')
            .length,
        color: const Color(0xFF823AF8),
        icon: Icons.bar_chart_rounded,
      ),
      DashboardStatistics(
        title: 'Verified',
        value: bookSubmissions
            .where((element) => element.status == 'verified')
            .length,
        color: const Color(0xFF72D635),
        icon: Icons.bar_chart_rounded,
      ),
      DashboardStatistics(
        title: 'Rejected',
        value: bookSubmissions
            .where((element) => element.status == 'rejected')
            .length,
        color: const Color(0xFFD63F35),
        icon: Icons.bar_chart_rounded,
      ),
    ];
  }
}

Widget buildStatusWidget(String status) {
  late Color backgroundColor;
  late Color foregroundColor;
  if (status == 'verified') {
    backgroundColor = const Color(0x3372D635);
    foregroundColor = const Color(0xFF254710);
  } else if (status == 'pending') {
    backgroundColor = const Color(0x33823AF8);
    foregroundColor = const Color(0xFF2A1A6C);
  } else {
    backgroundColor = const Color(0x33D63F35);
    foregroundColor = const Color(0xFF5A1A10);
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: backgroundColor,
    ),
    child: Text(
      capitalize(status),
      style: TextStyle(
        color: foregroundColor,
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// class Book {
//   final int number;
//   final String title;
//   final String publisher;
//   final String genre;
//   final String status;
//   final String description;
//   final String language;
//   final String isbn;
//   final int numberOfPages;
//   final String publishDate;

//   Book({
//     required this.number,
//     required this.title,
//     required this.publisher,
//     required this.genre,
//     required this.status,
//     required this.description,
//     required this.language,
//     required this.isbn,
//     required this.numberOfPages,
//     required this.publishDate,
//   });

//   // Konstruktor `fromJson`
//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       number: json['number'],
//       title: json['title'],
//       publisher: json['publisher'],
//       genre: json['genre'],
//       status: json['status'],
//       description: json['description'],
//       language: json['language'],
//       isbn: json['isbn'],
//       numberOfPages: json['numberOfPages'],
//       publishDate: json['publishDate'],
//     );
//   }

//   // Metode `toJson`
//   Map<String, dynamic> toJson() {
//     return {
//       'number': number,
//       'title': title,
//       'publisher': publisher,
//       'genre': genre,
//       'status': status,
//       'description': description,
//       'language': language,
//       'isbn': isbn,
//       'numberOfPages': numberOfPages,
//       'publishDate': publishDate,
//     };
//   }
// }
