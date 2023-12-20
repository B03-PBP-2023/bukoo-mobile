import 'package:bukoo/admin_dashboard/admin_dash.dart';
import 'package:bukoo/book_collection/screens/home_page.dart';
import 'package:bukoo/book_collection/widgets/custom_autocomplete_text_field.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/models/user.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/core/widgets/loading_layer.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookSubmissionPage extends StatefulWidget {
  const BookSubmissionPage({super.key});

  static const routeName = '/book-submission';

  @override
  State<BookSubmissionPage> createState() => _BookSubmissionPageState();
}

class _BookSubmissionPageState extends State<BookSubmissionPage> {
  static const heightOnTop = 100.0;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _publisher = TextEditingController();
  final TextEditingController _isbn = TextEditingController();
  final TextEditingController _language = TextEditingController();
  final TextEditingController _numPages = TextEditingController();
  final TextEditingController _publishDate = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final List<String> _selectedGenres = [];
  final List<String> _selectedAuthors = [];
  File? _imageFile;

  // init state
  @override
  void initState() {
    super.initState();
    _selectedAuthors.add(context.read<User>().name!);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<List<String>> getGenres() async {
      final response = await request.get("$BASE_URL/api/genre/");
      return response.cast<String>();
    }

    Future<List<String>> getAuthors() async {
      final response = await request.get("$BASE_URL/api/author/");
      return response.cast<String>();
    }

    void onSubmit() async {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        var request = http.MultipartRequest(
            'POST', Uri.parse("$BASE_URL/api/book/create/"));

        // Add headers
        var cookieRequest = Provider.of<CookieRequest>(context, listen: false);

        await cookieRequest.init();
        request.headers.addAll(cookieRequest.headers);

        // if (kIsWeb) {
        //   var cookie =
        //       'csrftoken=${getCookie('csrftoken')};sessionid=${getCookie('sessionid')}';
        //   request.headers.addAll({'cookie': cookie});
        // }

        request.fields['title'] = _title.text;
        request.fields['author'] = jsonEncode(_selectedAuthors);
        request.fields['publisher'] = _publisher.text;
        request.fields['publish_date'] = _publishDate.text;
        request.fields['num_pages'] = _numPages.text;
        request.fields['isbn'] = _isbn.text;
        request.fields['language'] = _language.text;
        request.fields['genres'] = _selectedGenres.join(',');
        request.fields['description'] = _description.text;

        if (_imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ));
        }

        var response = await request.send();
        if (response.statusCode == 201) {
          Map<String, dynamic> newBook = {
            'title': _title.text,
            'author': _selectedAuthors,
            'publisher': _publisher.text,
            'publish_date': _publishDate.text,
            'num_pages': _numPages.text,
            'isbn': _isbn.text,
            'language': _language.text,
            'genres': _selectedGenres,
            'description': _description.text,
            // tambahkan informasi lainnya sesuai kebutuhan
          };

          List<Map<String, dynamic>> submittedBooks = [newBook];

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AdminDash(
                  submittedBooks: [newBook]), // Tambahkan data buku ke sini
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Book submission Send!'),
            ),
          );
        } else {
          String body = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Book submission failed!. Error: $body'),
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Submission'),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.primary,
            ),
            ListView(
              children: [
                const SizedBox(
                  height: heightOnTop,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(64.0),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - heightOnTop,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 32.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Book Submission",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            CustomTextField(
                              controller: _title,
                              labelText: 'Title',
                              hintText: 'Book\'s title...',
                            ),
                            const SizedBox(height: 16.0),
                            CustomAutoCompleteTextField(
                                selectedItems: _selectedAuthors,
                                future: getAuthors,
                                label: 'Author',
                                hintText: 'Add more authors...',
                                addItem: (String item) {
                                  setState(() {
                                    _selectedAuthors.add(item);
                                  });
                                },
                                removeItem: (String item) {
                                  setState(() {
                                    if (item != context.read<User>().name!) {
                                      _selectedAuthors.remove(item);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'You cannot remove yourself as an author')));
                                    }
                                  });
                                }),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _publisher,
                              labelText: 'Publisher',
                              hintText: 'Book\'s publisher...',
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _publishDate,
                              labelText: 'Publish Date',
                              hintText: '2000-12-31',
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                try {
                                  DateFormat('yyyy-MM-dd').parseStrict(value!);
                                  return null;
                                } catch (e) {
                                  return 'The format must be yyyy-MM-dd';
                                }
                              },
                              suffixIcon: InkWell(
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1800),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      _publishDate.text = formattedDate;
                                    }
                                  },
                                  child: const Icon(
                                      Icons.calendar_month_outlined)),
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _numPages,
                              labelText: 'Number of Pages',
                              hintText: 'Book\'s number of pages...',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (int.tryParse(value!) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return 'This field must be a positive integer';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _isbn,
                              labelText: 'ISBN',
                              hintText: 'Book\'s ISBN...',
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _language,
                              labelText: 'Language',
                              hintText: 'Book\'s language...',
                            ),
                            const SizedBox(height: 16.0),
                            CustomAutoCompleteTextField(
                                selectedItems: _selectedGenres,
                                future: getGenres,
                                label: 'Genre',
                                hintText: 'Book\'s genres...',
                                addItem: (String item) {
                                  print('addItem called with: $item');
                                  setState(() {
                                    _selectedGenres.add(item);
                                  });
                                },
                                removeItem: (String item) {
                                  setState(() {
                                    _selectedGenres.remove(item);
                                  });
                                }),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                                controller: _description,
                                labelText: 'Description',
                                hintText: 'Book\'s description...',
                                maxLines: null,
                                minLines: 5),
                            const SizedBox(height: 16.0),
                            // Image
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Cover Image',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500)),
                                TextButton(
                                    onPressed: _pickImage,
                                    child: const Text(
                                      'Pick Image',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16.0),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            if (_imageFile != null)
                              Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, right: 16.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            _imageFile!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                (2 * 0.625),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[200],
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                _imageFile = null;
                                              });
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                              ),

                            const SizedBox(height: 32.0),
                            PrimaryButton(
                                onPressed: onSubmit,
                                child: const Text('Submit')),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
            LoadingLayer(isLoading: isLoading)
          ],
        ));
  }
}

mixin response {}
