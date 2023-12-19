import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:bukoo/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomAutoCompleteTextField extends StatelessWidget {
  final Future<List<String>> Function() future;
  final Function(String) addItem;
  final Function(String) removeItem;
  final List<String> selectedItems;
  final String label;
  final String hintText;

  const CustomAutoCompleteTextField(
      {super.key,
      required this.future,
      required this.addItem,
      required this.removeItem,
      required this.label,
      required this.hintText,
      required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: CustomTextField.inputDecoration.copyWith(
                  hintText: hintText,
                  suffixIcon: InkWell(
                    onTap: () {
                      String item = controller.text;
                      if (!selectedItems.contains(item) && item.isNotEmpty) {
                        addItem(item);
                      }
                    },
                    child: const Icon(Icons.add_circle_outline),
                  )),
            );
          },
          suggestionsCallback: (pattern) async {
            var response = await future();
            return response.where((item) {
              return item.toLowerCase().contains(pattern.toLowerCase());
            }).toList();
          },
          itemBuilder: (context, suggestion) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(suggestion),
                ],
              ),
            );
          },
          onSelected: (suggestion) {
            addItem(suggestion);
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
