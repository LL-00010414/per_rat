import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/screens/anime_details.dart';
import 'package:per_rat/screens/new_anime.dart';
import 'package:per_rat/widgets/anime_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    //required this.chosenAnime,
  });

  //final List<Anime> chosenAnime;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Anime> _registeredAnime = [];
  var _isLoading = true;
  String? _error;
  final user = FirebaseAuth.instance.currentUser!;

  void lastOnline() {
    var yourRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    yourRef.get().then((doc) => {
          if (!doc.exists)
            {print('No such document')}
          else
            {
              if (doc.get('last_online') != null)
                {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'last_online': Timestamp.now(),
                  })
                }
              else
                {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'last_online': Timestamp.now(),
                  })
                }
            }
        });
  }

  // void updateUserLastOnline() {
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  //     'last_online': Timestamp.now(),
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fetchAnime();
    lastOnline();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
    });
  }

  void _addAnime(Anime anime) {
    setState(() {
      _registeredAnime.add(anime);
    });
  }

  void _addAnimePage() async {
    final newAnime = await Navigator.of(context).push<Anime>(
      MaterialPageRoute(
        builder: (ctx) => NewAnime(onAddAnime: _addAnime),
      ),
    );

    if (newAnime == null) {
      return;
    }

    setState(() {
      _registeredAnime.add(newAnime);
    });
  }

  void selectAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
          anime: anime,
        ),
      ),
    );
  }

  void _removeAnime(Anime anime) async {
    await removeAnime(context, _registeredAnime, anime);
    setState(() {
      _registeredAnime = _registeredAnime;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No shows are present',
        style: TextStyle(color: Colors.white),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_registeredAnime.isNotEmpty) {
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: _registeredAnime.length,
        itemBuilder: (ctx, index) => AnimeItem(
          anime: _registeredAnime[index],
          onSelectAnime: (anime) {
            selectAnime(context, anime);
          },
          onDeleteAnime: (anime) {
            _removeAnime(anime);
          },
        ),
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [
          IconButton(
            onPressed: _addAnimePage,
            icon: const Icon(Icons.add_sharp),
          )
        ],
      ),
      body: content,
    );
  }
}
