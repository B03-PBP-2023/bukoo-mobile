import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomAutoCompleteTextField extends StatelessWidget {
  final Future<dynamic> Function() future;
  final Function(String) addItem;
  final Function(String) removeItem;
  final List<String> selectedItems;
  final String label;
  final String hintText;
  final GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey;

  const CustomAutoCompleteTextField(
      {super.key,
      required this.future,
      required this.addItem,
      required this.removeItem,
      required this.label,
      required this.hintText,
      required this.selectedItems,
      required this.autoCompleteKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        FutureBuilder(
          future: future(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AutoCompleteTextField<String>(
                key: autoCompleteKey,
                suggestions: snapshot.data!,
                minLength: 0,
                suggestionsAmount: 10,
                decoration: CustomTextField.inputDecoration.copyWith(
                    hintText: hintText,
                    suffixIcon: InkWell(
                      onTap: () {
                        String item = autoCompleteKey
                            .currentState!.textField!.controller!.text;
                        if (!snapshot.data!.contains(item) && item.isNotEmpty) {
                          snapshot.data!.add(item);
                          addItem(item);
                        }
                      },
                      child: const Icon(Icons.add_circle_outline),
                    )),
                itemFilter: (item, query) {
                  return item.toLowerCase().startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.compareTo(b);
                },
                itemSubmitted: (item) {
                  addItem(item);
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
              return Text('Failed to load: ${snapshot.error}');
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
          children: selectedItems.map((String item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                removeItem(item);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
