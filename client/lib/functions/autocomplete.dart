import 'package:flutter/material.dart';
import 'package:hotel_prive/constant/constant.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AutocompleteField extends StatefulWidget {
  final InputDecoration decoration;
  final FocusNode hotelsFocusNode;
  final Function(List<String>) onHotelIdsChanged;

  AutocompleteField({
    required this.decoration,
    required this.hotelsFocusNode,
    required this.onHotelIdsChanged,
  });

  @override
  _AutoCompleteWidgetState createState() => _AutoCompleteWidgetState();
}

class _AutoCompleteWidgetState extends State<AutocompleteField> {
  final TextEditingController _typeAheadController = TextEditingController();
  final List<String> selectedHotels = [];
  final List<String> selectedHotelIds = [];
  List<Map<String, String>> hotelSuggestions = [];

  Future<List<Map<String, String>>> _getHotelSuggestions(String query) async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/v1/hotels?name=$query'));

    if (response.statusCode == 200) {
      final List hotels = json.decode(response.body);
      print('API Response: $hotels'); // Debug print
      hotelSuggestions = hotels.map((hotel) => {
        'name': hotel['name'].toString(),
        'id': hotel['id'].toString()
      }).toList();
      print('Mapped Hotels: $hotelSuggestions'); // Debug print
      return hotelSuggestions;
    } else {
      print('Failed to load hotel names'); // Debug print
      throw Exception('Failed to load hotel names');
    }
  }

  Future<List<String>> suggestionsCallback(String pattern) async {
    if (pattern.length < 2) {
      return [];
    }

    return Future<List<String>>.delayed(
      Duration(milliseconds: 300),
      () async {
        print('Pattern: $pattern'); // Debug print
        final suggestions = await _getHotelSuggestions(pattern);
        return suggestions.map((suggestion) => suggestion['name']!).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _typeAheadController,
            style: inputLoginTextStyle,
            decoration: widget.decoration,
            focusNode: widget.hotelsFocusNode,
          ),
          suggestionsCallback: suggestionsCallback,
          itemBuilder: (context, suggestion) {
            print('Suggestion: $suggestion'); // Debug print
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (suggestion) {
            setState(() {
              _typeAheadController.text = suggestion;
              selectedHotels.add(suggestion);
              selectedHotelIds.add(getHotelId(suggestion));
              _typeAheadController.clear(); // Clear the text field
              widget.onHotelIdsChanged(selectedHotelIds); // Call the callback function
              print('Selected Hotel IDs: $selectedHotelIds'); // Debug print
            });
          },
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: selectedHotels.map((hotel) {
            return Chip(
              label: Text(hotel),
              onDeleted: () {
                setState(() {
                  int index = selectedHotels.indexOf(hotel);
                  selectedHotels.removeAt(index);
                  selectedHotelIds.removeAt(index);
                  widget.onHotelIdsChanged(selectedHotelIds); // Call the callback function
                  print('Selected Hotel IDs: $selectedHotelIds'); // Debug print
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Method to get hotel ID from suggestion
  String getHotelId(String suggestion) {
    final hotel = hotelSuggestions.firstWhere(
      (hotel) => hotel['name'] == suggestion,
      orElse: () => {'id': 'unknown'},
    );
    return hotel['id']!;
  }
}