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
              // DropdownButton<String>(
              //   value: selectedStatus,
              //   items: <String>['Pending', 'Rejected', 'Verified']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectedStatus =
              //           newValue ?? selectedStatus; // Mengubah status
              //     });
              //   },
              // ),
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

// import 'package:flutter/material.dart';
// import 'package:bukoo/admin_dashboard/admin_dash.dart';

// void main() {
//   runApp( DetailAdminPage());
// }

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
// class DetailAdminPage extends StatelessWidget {
//   final Book book; // Menerima objek buku

//   DetailAdminPage({Key? key, required this.book}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
//       ),
//       home: Scaffold(
//         body: ListView(children: [
//           AdminDahsboardMobile(),
//         ]),
//       ),
//     );
//   }
// }

// class AdminDahsboardMobile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 390,
//           height: 844,
//           clipBehavior: Clip.antiAlias,
//           decoration: BoxDecoration(color: Color(0xFFADC4CE)),
//           child: Stack(
//             children: [
//               Positioned(
//                 left: 29,
//                 top: 101,
//                 child: Container(
//                   width: 330,
//                   height: 321,
//                   decoration: ShapeDecoration(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(23),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 7.20,
//                         offset: Offset(0, 3),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 0,
//                 top: -25,
//                 child: Container(
//                   width: 390,
//                   height: 95,
//                   decoration: ShapeDecoration(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 7.20,
//                         offset: Offset(0, 3),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 49,
//                 top: 127,
//                 child: SizedBox(
//                   width: 291,
//                   height: 282,
//                   child: Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Title: Surat Cinta\n',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             height: 0.05,
//                           ),
//                         ),
//                         TextSpan(
//                           text:
//                               'Description: Menceritakan tentang keresahan mahasiswa yang sedang mengerjakan TP SDA dan berkelahi dengan grader sofita\n',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             height: 0.06,
//                           ),
//                         ),
//                         TextSpan(
//                           text:
//                               '\nGenres: Romance\nPublisher: Sofita\nLanguage: Indonesia\nISBN: 220898 \nNumber Pages: 150\nPublish Date: 19 Februari 2022',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             height: 0.05,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 377,
//                 top: 360,
//                 child: Container(
//                   width: 3,
//                   height: 156,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFF727070),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 78,
//                 top: 22,
//                 child: Text(
//                   'Admin Dashboard - Book Submission',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 13,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     height: 0.14,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 29,
//                 top: 23,
//                 child: Container(
//                   width: 24,
//                   height: 24,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(),
//                   child: Stack(children: []),
//                 ),
//               ),
//               Positioned(
//                 left: 29,
//                 top: 495,
//                 child: Container(
//                   width: 329,
//                   height: 212,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           width: double.infinity,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   width: double.infinity,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Respons',
//                                         style: TextStyle(
//                                           color: Color(0xFF344053),
//                                           fontSize: 16,
//                                           fontFamily: 'Inter',
//                                           fontWeight: FontWeight.w500,
//                                           height: 0.08,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Expanded(
//                                         child: Container(
//                                           width: double.infinity,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 14, vertical: 10),
//                                           clipBehavior: Clip.antiAlias,
//                                           decoration: ShapeDecoration(
//                                             color: Colors.white,
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                   width: 1,
//                                                   color: Color(0xFFCFD4DC)),
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                             shadows: [
//                                               BoxShadow(
//                                                 color: Color(0x0C101828),
//                                                 blurRadius: 2,
//                                                 offset: Offset(0, 1),
//                                                 spreadRadius: 0,
//                                               )
//                                             ],
//                                           ),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 child: SizedBox(
//                                                   height: double.infinity,
//                                                   child: Text(
//                                                     'Enter a respon...',
//                                                     style: TextStyle(
//                                                       color: Color(0xFFADC4CE),
//                                                       fontSize: 16,
//                                                       fontFamily: 'Inter',
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       height: 0.09,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 29,
//                 top: 726,
//                 child: Container(
//                   width: 329,
//                   height: 37,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 0,
//                         top: 0,
//                         child: Container(
//                           width: 329,
//                           height: 37,
//                           decoration: ShapeDecoration(
//                             color: Color(0xFF354259),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 149.09,
//                         top: 8.76,
//                         child: Text(
//                           'Send',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w500,
//                             height: 0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 31,
//                 top: 432,
//                 child: Container(
//                   width: 328,
//                   height: 146,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(width: 1, color: Color(0xFFF2F3F6)),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Color(0x07101828),
//                         blurRadius: 6,
//                         offset: Offset(0, 4),
//                         spreadRadius: -2,
//                       ),
//                       BoxShadow(
//                         color: Color(0x14101828),
//                         blurRadius: 16,
//                         offset: Offset(0, 12),
//                         spreadRadius: -4,
//                       )
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0x8E8239F7),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Pending',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 decoration:
//                                     BoxDecoration(color: Color(0xFFF8F9FB)),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0x3DD53535),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Reject',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: 20,
//                                       height: 20,
//                                       clipBehavior: Clip.antiAlias,
//                                       decoration: BoxDecoration(),
//                                       child: Stack(children: []),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0x7072D535),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Verify',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0xFF12B669),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Ava Wright',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0xFF12B669),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Eve Leroy',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 14, vertical: 10),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         height: 24,
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width: 10,
//                                               height: 10,
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned(
//                                                     left: 1,
//                                                     top: 1,
//                                                     child: Container(
//                                                       width: 8,
//                                                       height: 8,
//                                                       decoration:
//                                                           ShapeDecoration(
//                                                         color:
//                                                             Color(0xFF12B669),
//                                                         shape: OvalBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Zahir Mays',
//                                               style: TextStyle(
//                                                 color: Color(0xFF0F1728),
//                                                 fontSize: 16,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w500,
//                                                 height: 0.09,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
