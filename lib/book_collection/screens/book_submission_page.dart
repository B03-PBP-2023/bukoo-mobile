import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/left_drawer.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BookSubmissionPage extends StatefulWidget {
  BookSubmissionPage({super.key});

  static const routeName = '/book-submission';

  @override
  State<BookSubmissionPage> createState() => _BookSubmissionPageState();
}

class _BookSubmissionPageState extends State<BookSubmissionPage> {
  static const HEIGHT_ON_TOP = 100.0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<AutoCompleteTextFieldState<String>> _autoCompleteKey =
      GlobalKey();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _publisher = TextEditingController();
  final TextEditingController _isbn = TextEditingController();
  final TextEditingController _language = TextEditingController();
  final TextEditingController _numPages = TextEditingController();
  final TextEditingController _publishDate = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final List<String> _selectedGenres = [];
  File? _imageFile;

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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Submission'),
        ),
        drawer: const LeftDrawer(),
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
                  height: HEIGHT_ON_TOP,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(64.0),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - HEIGHT_ON_TOP,
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
                            CustomTextField(
                              controller: _author,
                              labelText: 'Author',
                              hintText: 'Book\'s author...',
                            ),
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
                            // Genre

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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Genres',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500)),
                                FutureBuilder(
                                  future: getGenres(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return AutoCompleteTextField<String>(
                                        key: _autoCompleteKey,
                                        suggestions: snapshot.data!,
                                        minLength: 0,
                                        decoration: CustomTextField
                                            .inputDecoration
                                            .copyWith(
                                                hintText: 'Book\'s genres...'),
                                        itemFilter: (item, query) {
                                          return item
                                              .toLowerCase()
                                              .startsWith(query.toLowerCase());
                                        },
                                        itemSorter: (a, b) {
                                          return a.compareTo(b);
                                        },
                                        itemSubmitted: (item) {
                                          setState(() {
                                            _selectedGenres.add(item);
                                          });
                                        },
                                        itemBuilder: (context, item) {
                                          return Container(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              children: [
                                                Text(item),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Failed to load genres: ${snapshot.error}');
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                Wrap(
                                  spacing: 5.0,
                                  runSpacing: 5.0,
                                  children: _selectedGenres.map((String genre) {
                                    return Chip(
                                      label: Text(genre),
                                      onDeleted: () {
                                        setState(() {
                                          _selectedGenres.remove(genre);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')));
                                  }
                                },
                                child: const Text('Submit')),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
