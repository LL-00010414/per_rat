import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:http/http.dart' as http;
import 'package:per_rat/models/demographics.dart';
import 'package:per_rat/models/genres.dart';
import 'package:per_rat/models/statuses.dart';
import 'package:per_rat/models/studios.dart';

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
  var _enteredSynopsis = [''];
  var _enteredTotalEpisodes = 12;
  var _enteredScore = 5.5;
  var _enteredRank = 1000;
  var _enteredPopularity = 700;
  var _enteredFavorites = 140;
  var _enteredTrailerUrl = '';
  var _selectedGenre = genres[Genres.action]!;
  var _selectedDemographic = demographics[Demographics.g]!;
  var _selectedStudio = studios[Studios.a1Pictures]!;
  var _selectedStatus = statuses[Statuses.completed]!;
  //DateTimes were done different
  var _selectedStartDate = DateTime.now();
  var _selectedEndDate = DateTime.now().add(const Duration(days: 90));
  //other variables
  var _isSending = false;

  void _startDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(1950, 1, 1);
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: now);
    setState(() {
      _selectedStartDate = pickedDate!;
      if (_selectedStartDate.isAfter(_selectedEndDate)) {
        _selectedEndDate = _selectedStartDate;
      }
      // if (_selectedEndDate.isAfter(_selectedStartDate)) {
      //   _selectedEndDate = _selectedEndDate.add(const Duration(days: 90));
      // }
    });
  }

  void _endDatePicker() async {
    final now = DateTime.now().add(const Duration(days: 90));
    final firstDate = DateTime(1950, 1, 1);
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: now);
    setState(() {
      _selectedEndDate = pickedDate!;
      if (_selectedEndDate.isBefore(_selectedStartDate)) {
        _selectedStartDate = _selectedEndDate;
      }
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
          'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
          'movie-list.json');
      final response = await http.post(
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
            'genre': _selectedGenre.title,
            'demographics': _selectedDemographic.title,
            'studio': _selectedStudio.title,
            'status': _selectedStatus.title,
            'startDate': formatter.format(_selectedStartDate),
            'endDate': formatter.format(_selectedEndDate),
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        Anime(
          id: resData['name'],
          title: _enteredTitle,
          imageUrl: _enteredImageUrl,
          synopsis: _enteredSynopsis,
          totalEpisodes: _enteredTotalEpisodes,
          score: _enteredScore.toString(),
          rank: _enteredRank.toString(),
          popularity: _enteredPopularity.toString(),
          favorites: _enteredFavorites,
          trailerUrl: _enteredTrailerUrl,
          genre: _selectedGenre,
          demographic: _selectedDemographic,
          studio: _selectedStudio,
          status: _selectedStatus,
          startDate: _selectedStartDate,
          endDate: _selectedEndDate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new show'),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        //itemExtent: 1000,
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                      label: const Text('Title'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ),
                ), // instead of TextField()

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Genre:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 165,
                          child: DropdownButtonFormField(
                            menuMaxHeight: 250,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            //style: TextStyle(color: Colors.amber),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                            dropdownColor:
                                Theme.of(context).colorScheme.outlineVariant,
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            value: _selectedGenre,
                            items: [
                              for (final genre in genres.entries)
                                DropdownMenuItem(
                                  enabled: true,
                                  value: genre.value,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      Text(genre.value.title),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGenre = value!;
                              });
                            },
                            onSaved: (value) {
                              _selectedGenre = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Demographics:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 165,
                          child: DropdownButtonFormField(
                            menuMaxHeight: 250,
                            //style: TextStyle(color: Colors.amber),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                            dropdownColor:
                                Theme.of(context).colorScheme.outlineVariant,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            //style: TextStyle(color: Colors.amber),
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                            ),
                            value: _selectedDemographic,
                            items: [
                              for (final demographic in demographics.entries)
                                DropdownMenuItem(
                                  enabled: true,
                                  value: demographic.value,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 6),
                                      Text(demographic.value.title),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDemographic = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //const SizedBox(height: 12),

                //const SizedBox(height: 12),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Studio:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: SizedBox(
                    width: 650,
                    child: DropdownButtonFormField(
                      menuMaxHeight: 250,
                      //style: TextStyle(color: Colors.amber),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                      dropdownColor:
                          Theme.of(context).colorScheme.outlineVariant,

                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      //style: TextStyle(color: Colors.amber),
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      value: _selectedStudio,
                      items: [
                        for (final studio in studios.entries)
                          DropdownMenuItem(
                            enabled: true,
                            value: studio.value,
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(studio.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStudio = value!;
                        });
                      },
                    ),
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Status:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    left: 5,
                  ),
                  child: SizedBox(
                    width: 650,
                    child: DropdownButtonFormField(
                      menuMaxHeight: 250,
                      //style: TextStyle(color: Colors.amber),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                      dropdownColor:
                          Theme.of(context).colorScheme.outlineVariant,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      //style: TextStyle(color: Colors.amber),
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      value: _selectedStatus,
                      items: [
                        for (final status in statuses.entries)
                          DropdownMenuItem(
                            enabled: true,
                            value: status.value,
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Text(status.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        maxLength: 10,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Score'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredScore.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null ||
                              double.tryParse(value)! < 0) {
                            return 'Must be a valid, positive number.';
                          } else if (double.tryParse(value)! > 10) {
                            return 'The score cannot be over 10';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredScore = double.parse(value!);
                        },
                      ),
                    ),
                    //const SizedBox(width: 88),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        maxLength: 10,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Rank'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredRank.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredRank = int.parse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        maxLength: 8,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          label: Text('Total Episodes'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredTotalEpisodes.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredTotalEpisodes = int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        maxLength: 10,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Popularity'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredPopularity.toString(),
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
                          _enteredPopularity = int.parse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        maxLength: 10,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Favorites'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredFavorites.toString(),
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
                          _enteredFavorites = int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 50,
                      ),
                      child: Text(
                        'Start Date:',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 50,
                      ),
                      child: Text(
                        'End Date:',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            formatter.format(_selectedStartDate),
                            style: const TextStyle(color: Colors.white),
                            // if _selectedStartDate == null
                            //   'Pick a Date';

                            // else
                            //   formatter.format(_selectedStartDate!);
                          ),
                          IconButton(
                            onPressed: _startDatePicker,
                            icon: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            formatter.format(_selectedEndDate),
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            onPressed: _endDatePicker,
                            icon: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLength: 280,
                    decoration: const InputDecoration(
                      label: Text('Image URL'),
                      labelStyle: TextStyle(color: Colors.amber),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 5 ||
                          value.trim().length > 280 ||
                          !value.endsWith('png') && !value.endsWith('jpg')) {
                        return 'Must provide a valid URL';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredImageUrl = value!;
                    },
                  ),
                ), // instead of TextField()
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLength: 180,
                    decoration: const InputDecoration(
                      label: Text('Trailer URL'),
                      labelStyle: TextStyle(color: Colors.amber),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 5 ||
                          value.trim().length > 180 ||
                          !value.startsWith('https:')) {
                        return 'Must provide a valid URL';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // if (value == null) {
                      //   return;
                      // }
                      _enteredTrailerUrl = value!;
                    },
                  ),
                ), // instead of TextField()
                const SizedBox(height: 22),

                TextFormField(
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  //initialValue: 'Synopsis',
                  maxLength: 1000,
                  maxLines: 15,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    errorMaxLines: 6,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    helperMaxLines: 8,
                    hintText: 'Provide a description for the show...',
                    hintStyle:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    hintMaxLines: 6,
                    contentPadding: EdgeInsets.all(20),
                    border: OutlineInputBorder(),
                    label: Text(
                      'Description',
                    ),
                    labelStyle: TextStyle(color: Colors.amber),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 10 ||
                        value.trim().length > 1000) {
                      return 'Must be between 10 and 1000 characters.';
                    }
                    return null;
                  },
                  onSaved: ([value]) {
                    _enteredSynopsis = [value!];
                  },
                ), // instead of TextField()
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Add Item"),
                    )
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
