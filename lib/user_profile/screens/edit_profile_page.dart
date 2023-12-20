import 'package:bukoo/book_collection/widgets/custom_autocomplete_text_field.dart';
import 'package:bukoo/core/config.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:bukoo/core/widgets/loading_layer.dart';
import 'package:bukoo/core/widgets/primary_button.dart';
import 'package:bukoo/user_profile/models/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileData profileData;
  const EditProfilePage({super.key, required this.profileData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final List<String> _selectedGenres = [];
  String? _gender = "male";
  bool _isLoading = false;

  final genderOptions = ["male", "female"];

  @override
  void initState() {
    super.initState();
    _name.text = widget.profileData.name ?? "";
    _dateOfBirth.text = widget.profileData.dateOfBirth == null
        ? ''
        : DateFormat('yyyy-MM-dd').format(widget.profileData.dateOfBirth!);
    _gender = widget.profileData.gender != null
        ? widget.profileData.gender!.toLowerCase()
        : "male";
    _about.text = widget.profileData.about ?? "";
    _selectedGenres.addAll(widget.profileData.preferredGenre!.split(','));
  }

  Future<List<String>> getGenres() async {
    final request = context.read<CookieRequest>();
    final response = await request.get("$BASE_URL/api/genre/");
    return response.cast<String>();
  }

  void onSave() async {
    setState(() {
      _isLoading = true;
    });
    final request = context.read<CookieRequest>();
    final response = await request.post('$BASE_URL/profile/edit-profile/', {
      "name": _name.text,
      "gender": _gender,
      "date_of_birth": _dateOfBirth.text,
      "about_user": _about.text,
      "prefered_genre": _selectedGenres.join(','),
      "profile_picture": widget.profileData.profilePictureUrl ?? '',
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile!'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 48.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(64.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text('Edit Profile',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(controller: _name, labelText: 'Name'),
                          const SizedBox(height: 16),
                          const Text('Gender',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500)),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text("Select gender"),
                                value: _gender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _gender = newValue;
                                  });
                                },
                                items: genderOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _dateOfBirth,
                            labelText: 'Date of Birth',
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
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                    _dateOfBirth.text = formattedDate;
                                  }
                                },
                                child:
                                    const Icon(Icons.calendar_month_outlined)),
                          ),
                          const SizedBox(height: 16),
                          CustomAutoCompleteTextField(
                              selectedItems: _selectedGenres,
                              future: getGenres,
                              label: 'Genre',
                              hintText: 'Book\'s genres...',
                              addItem: (String item) {
                                setState(() {
                                  _selectedGenres.add(item);
                                });
                              },
                              removeItem: (String item) {
                                setState(() {
                                  _selectedGenres.remove(item);
                                });
                              }),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _about,
                            labelText: 'About',
                            maxLines: 5,
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                              onPressed: onSave, child: const Text('Save'))
                        ],
                      ),
                    ),
                  ],
                ),
                LoadingLayer(isLoading: _isLoading)
              ],
            ),
          );
        },
      ),
    );
  }
}
