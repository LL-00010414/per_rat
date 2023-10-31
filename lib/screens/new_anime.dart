import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';
import 'package:http/http.dart' as http;

class NewAnime extends StatefulWidget {
  const NewAnime({
    super.key,
    required this.onAddAnime,
  });

  final void Function(Anime anime) onAddAnime;

  @override
  State<NewAnime> createState() => _NewAnimeState();
}

class _NewAnimeState extends State<NewAnime> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredImageUrl = '';
  var _enteredSynopsis = '';
  var _enteredTotalEpisodes = 12;
  var _enteredScore = '5';
  var _enteredRank = '';
  var _enteredPopularity = '';
  var _enteredFavorites = 0;
  var _enteredTrailerUrl = '';
  //var _selectedGenre = Genre.adventure;
  //var _enteredDemographics = Demographics.shounen;
  //var _enteredStudio = Studio.a1Pictures;
  var _enteredStatus = 'Completed';
  // var _enteredStartDate = DateTime.now();
  // var _enteredEndDate = DateTime.now();

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
          'anime-list.json');
      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredTitle,
            'imageUrl': _enteredImageUrl,
            'synopsis': _enteredSynopsis,
            'totalEpisodes': _enteredTotalEpisodes,
            'score': _enteredScore,
            'rank': _enteredRank,
            'popularity': _enteredPopularity,
            'favorites': _enteredFavorites,
            'trailerUrl': _enteredTrailerUrl,
            //'genre': _selectedGenre,
            //'demographics': _enteredDemographics,
            //'studio': _enteredStudio,
            'status': _enteredStatus,
            // 'startDate': _enteredStartDate,
            // 'endDate': _enteredEndDate,
          },
        ),
      );
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _enteredTitle = value!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Total Epdisodes'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredTotalEpisodes.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredTotalEpisodes = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _enteredTitle = value!;
                },
              ), // instead of TextField()
              const SizedBox(height: 12),
              TextFormField(
                maxLength: 500,
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 10 ||
                      value.trim().length > 500) {
                    return 'Must be between 10 and 500 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }
                  _enteredTitle = value!;
                },
              ), // instead of TextField()
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
