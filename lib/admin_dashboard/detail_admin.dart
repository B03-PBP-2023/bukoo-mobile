// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:bukoo/admin_dashboard/admin_dash.dart';
import 'package:bukoo/admin_dashboard/models/book_submission.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/loading_layer.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailAdminPage extends StatefulWidget {
  final BookSubmission bookSubmission; // Menerima objek buku
  const DetailAdminPage({super.key, required this.bookSubmission});

  @override
  _DetailAdminPageState createState() => _DetailAdminPageState();
}

class _DetailAdminPageState extends State<DetailAdminPage> {
  late String selectedStatus; // Variabel untuk status yang dipilih
  late String currentStatus; // Tambahkan definisi untuk currentStatus
  final TextEditingController _responseController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.bookSubmission.status;
    currentStatus = selectedStatus;
    _responseController.text = widget.bookSubmission.feedback ?? '';
  }

  void onSubmit() async {
    setState(() {
      isLoading = true;
    });
    final request = context.read<CookieRequest>();
    final response = await request.postJson(
      '$BASE_URL/api/admin-dashboard/edit/${widget.bookSubmission.id}/',
      jsonEncode({
        'status': selectedStatus,
        'feedback': _responseController.text,
      }),
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book submission updated'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      shadows: const [
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
                          const SizedBox(height: 16),
                          Text(
                            "Title: ${widget.bookSubmission.book.title}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign:
                                TextAlign.center, // Atur rata tengah di sini
                          ),
                          Text(
                              "Description: ${widget.bookSubmission.book.description}"),
                          Text(
                              "Genre: ${widget.bookSubmission.book.genres!.join(', ')}"),
                          Text(
                              "Publisher: ${widget.bookSubmission.book.publisher}"),
                          Text(
                              "Language: ${widget.bookSubmission.book.language}"),
                          Text("ISBN: ${widget.bookSubmission.book.isbn}"),
                          Text(
                              "Number of Pages: ${widget.bookSubmission.book.numPages}"),
                          Text(
                              "Publish Date: ${widget.bookSubmission.book.publishDate}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Status',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary)),
                  const SizedBox(height: 8),
                  _customDropdown(context),
                  const SizedBox(height: 16),
                  Text('Response',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextFormField(
                      controller: _responseController,
                      decoration: CustomTextField.inputDecoration.copyWith(
                        fillColor: Colors.white,
                        hintText: 'Enter a response',
                      ),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                      onPressed: onSubmit,
                      child: const Text(
                          'Submit')), // Lanjutan kode untuk text field dan tombol send
                ],
              ),
            ),
          ),
          LoadingLayer(isLoading: isLoading)
        ],
      ),
    );
  }

  Widget _customDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomDropdown(context),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF2F3F6)),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x07101828),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -2,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.circle, color: _getColorForStatus(currentStatus)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                capitalize(currentStatus),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: <String>['pending', 'rejected', 'verified']
                .map((String value) => ListTile(
                      leading:
                          Icon(Icons.circle, color: _getColorForStatus(value)),
                      title: Text(capitalize(value)),
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
      case 'pending':
        return const Color(0x8E8239F7);
      case 'rejected':
        return const Color(0x3DD53535);
      case 'verified':
        return const Color(0x7072D535);
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
