import 'package:flutter/material.dart';
import 'package:bukoo/admin_dashboard/admin_dash.dart';

class DetailAdminPage extends StatefulWidget {
  final Book book; // Menerima objek buku

  DetailAdminPage({Key? key, required this.book}) : super(key: key);

  @override
  _DetailAdminPageState createState() => _DetailAdminPageState();
}

class _DetailAdminPageState extends State<DetailAdminPage> {
  late String selectedStatus; // Variabel untuk status yang dipilih
  late String currentStatus; // Tambahkan definisi untuk currentStatus
  final TextEditingController _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.book.status; // Mengatur status awal dari buku
    currentStatus = selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
      ),
      backgroundColor: Color(0xFFADC4CE),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 330,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 7.20,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: ${widget.book.title}"),
                      Text("Description: ${widget.book.description}"),
                      Text("Genre: ${widget.book.genre}"),
                      Text("Publisher: ${widget.book.publisher}"),
                      Text("Language: ${widget.book.language}"),
                      Text("ISBN: ${widget.book.isbn}"),
                      Text("Number of Pages: ${widget.book.numberOfPages}"),
                      Text("Publish Date: ${widget.book.publishDate}"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _customDropdown(context),
              SizedBox(height: 10),
              TextFormField(
                controller: _responseController,
                decoration: InputDecoration(
                  labelText: 'Respons',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk mengirim respons
                  // Contoh: Menampilkan teks di konsol
                  print('Response: ${_responseController.text}');
                },
                child: Text('Send'),
              ), // Lanjutan kode untuk text field dan tombol send
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomDropdown(context),
      child: Container(
        width: 328,
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFF2F3F6)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x07101828),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Color(0x14101828),
              blurRadius: 16,
              offset: Offset(0, 12),
              spreadRadius: -4,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentStatus,
              style: TextStyle(
                color: Color(0xFFADC4CE),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCustomDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: <String>['Pending', 'Rejected', 'Verified']
                .map((String value) => ListTile(
                      leading:
                          Icon(Icons.circle, color: _getColorForStatus(value)),
                      title: Text(value),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedStatus = value;
                          currentStatus = value;
                        });
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Color(0x8E8239F7);
      case 'Rejected':
        return Color(0x3DD53535);
      case 'Verified':
        return Color(0x7072D535);
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _responseController.dispose(); // Jangan lupa dispose controller
    super.dispose();
  }
}

