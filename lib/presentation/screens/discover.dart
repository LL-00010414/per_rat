import 'package:flutter/material.dart';
import 'package:per_rat/data/models/anime.dart';
import 'package:per_rat/presentation/screens/anime_details.dart';
import 'package:per_rat/presentation/screens/realtime_search.dart';
import 'package:per_rat/presentation/widgets/discover_anime_item.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.ongoingAnime,
    required this.trendingAnime,
    required this.upcomingAnime,
  });

  final List<Anime> ongoingAnime;
  final List<Anime> trendingAnime;
  final List<Anime> upcomingAnime;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // List<Anime> _registeredAnime = [];
  var searchName = '';

  @override
  void initState() {
    super.initState();
    // _fetchAnime();
  }

  // void _fetchAnime() async {
  //   List<Anime> loadedAnime = await loadAnimeFromFirestore();
  //   setState(() {
  //     _registeredAnime = loadedAnime;
  //   });
  // }

  void pickAnime(BuildContext context, Anime anime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AnimeDetailsScreen(
          anime: anime,
        ),
      ),
    );
  }

  // void tapSearch(BuildContext context) {
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (ctx) => SearchResultsScreen()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: TextField(
            canRequestFocus: false,
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => RealtimeSearchScreen(),
                ),
              );
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              filled: true,
              fillColor: Color.fromARGB(255, 39, 39, 39),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Ongoing',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  //itemExtent: 155,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.ongoingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.ongoingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Trending',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  //itemExtent: 155,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.trendingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.trendingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 8,
                ),
                child: Text(
                  'Upcoming',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 10),
                  itemCount: widget.upcomingAnime.length,
                  itemBuilder: (context, index) {
                    return DiscoverAnimeItem(
                      anime: widget.upcomingAnime[index],
                      onPickAnime: (anime) {
                        pickAnime(context, anime);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
