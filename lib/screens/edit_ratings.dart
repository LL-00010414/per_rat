import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/data/firestore_data.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/show_rating.dart';

class EditRatingsScreen extends StatefulWidget {
  const EditRatingsScreen({
    super.key,
    required this.showRating,
    required this.refreshParent,
  });

  final ShowRating showRating;
  final VoidCallback refreshParent;

  @override
  State<EditRatingsScreen> createState() => _EditRatingsScreenState();
}

class _EditRatingsScreenState extends State<EditRatingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Anime> _registeredAnime = [];
  Anime? animeSet;
  late ScrollController _scrollController;

  //colors for statuses
  Color? cCompleted;
  Color? cWatching;
  Color? cPTW;
  Color? cOnHold;
  Color? cDropped;

  //user score variables
  String? _selectedStatus = '';
  String? _selectedProgress = '';
  String? _selectedScore = '';

  @override
  void initState() {
    super.initState();
    _fetchAnime();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchAnime() async {
    List<Anime> loadedAnime = await loadAnimeFromFirestore();
    setState(() {
      _registeredAnime = loadedAnime;
      animeSet = getAnimeFromShowrating(
          widget.showRating); // Update animeSet after fetching anime list
    });
  }

  Anime? getAnimeFromShowrating(ShowRating showrating) {
    for (Anime anime in _registeredAnime) {
      if (anime.title == showrating.showName) {
        return anime;
      }
    }
    return null;
  }

  // void setAnime(ShowRating showrating) {
  //   Anime? animeSet = getAnimeFromShowrating(showrating);
  // }

  void _submit() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      CollectionReference ratingCollectionRef =
          userDocRef.collection('ratings');
      QuerySnapshot showDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('ratings')
          .get();

      final bool showExists = showDoc.docs
          .where((show) => show.id.contains(widget.showRating.showName))
          .isNotEmpty;

      if (showExists) {
        //
        await ratingCollectionRef.doc(widget.showRating.showName).set({
          'status': _selectedStatus,
          'progress': _selectedProgress,
          'score': _selectedScore,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The movie rating has been edited!'),
          ),
        );

        Navigator.of(context).pop();
      }
      if (!showExists) {
        await ratingCollectionRef.doc(widget.showRating.showName).set({
          'status': _selectedStatus,
          'progress': _selectedProgress,
          'score': _selectedScore,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The movie rating has been added!'),
          ),
        );

        widget.refreshParent;
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      if (error.code.isNotEmpty) {
        //
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
        ),
      );
    }
  }

  void selectStatus(int statusNumber) {
    setState(() {
      cCompleted = null;
      cWatching = null;
      cPTW = null;
      cOnHold = null;
      cDropped = null;
      if (statusNumber == 1) {
        cCompleted = Colors.blue;
        _selectedStatus = 'Completed';
        _selectedProgress = animeSet?.totalEpisodes.toString();
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else if (statusNumber == 2) {
        cWatching = Colors.green;
        _selectedStatus = 'Watching';
      } else if (statusNumber == 3) {
        cPTW = Colors.grey;
        _selectedStatus = 'Plan to Watch';
        _selectedProgress = '0';
        _scrollController.animateTo(
          0.0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else if (statusNumber == 4) {
        cOnHold = Colors.yellow;
        _selectedStatus = 'On Hold';
      } else if (statusNumber == 5) {
        cDropped = Colors.red;
        _selectedStatus = 'Dropped';
      }
    });
  }

  void selectProgress(int progress) {
    setState(() {
      _selectedProgress = progress.toString();
    });
  }

  void selectScore(int score) {
    setState(() {
      _selectedScore = score.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double buttonFontSize = 14;

    //setting Anime object

    //Anime? animeSet = getAnimeFromShowrating(widget.showRating);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            right: 15,
            left: 15,
            top: 20,
            bottom: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                animeSet?.title ?? '...',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Status:  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      //animeSet?.status.toString() ?? '...',
                      widget.showRating.status,
                      style: TextStyle(
                        color: (widget.showRating.status
                                .toString()
                                .contains('Upcoming')
                            ? Colors.blue
                            : widget.showRating.status
                                    .toString()
                                    .contains('Ongoing')
                                ? Colors.green
                                : Colors.purple),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: cCompleted,
                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      selectStatus(1);
                    },
                    child: const Text('Completed'),
                  ),

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: cWatching,

                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      selectStatus(2);
                    },
                    child: const Text('Watching'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: cPTW,
                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {
                      selectStatus(3);
                    },
                    child: const Text('Plan to Watch'),
                  ),

                  //failed new responsive buttons
                  // StatusButton(
                  //     statusColor: cCompleted,
                  //     status: 'Completed',
                  //     onPressed: () {
                  //       setState(() {
                  //         selectStatus(1);
                  //       });
                  //     }),
                  // StatusButton(
                  //     statusColor: cWatching,
                  //     status: 'Watching',
                  //     onPressed: () {
                  //       setState(() {
                  //         selectStatus(2);
                  //       });
                  //     }),
                  // StatusButton(
                  //     statusColor: cPTW,
                  //     status: 'Plan to Watch',
                  //     onPressed: () {
                  //       setState(() {
                  //         selectStatus(3);
                  //       });
                  //     }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      right: 3,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: cOnHold,
                          //padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: buttonFontSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        selectStatus(4);
                      },
                      child: Container(
                        child: const Text('On Hold'),
                        margin: EdgeInsets.symmetric(
                          horizontal: 9,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      right: 12,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: cDropped,
                          //padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: buttonFontSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        selectStatus(5);
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          child: const Text('Dropped')),
                    ),
                  ),
                ],
              ),
              const Text(
                'Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: ((animeSet?.totalEpisodes ?? 0) > 0)
                          ? (animeSet?.totalEpisodes ?? 0) + 1
                          : (animeSet?.totalEpisodes ?? 0) + 2,
                      itemBuilder: (context, index) {
                        int number = index;

                        return GestureDetector(
                          onTap: () {
                            selectProgress(number);
                          },
                          child: Container(
                            width:
                                50, // Adjust the width of each item as needed
                            height:
                                50, // Adjust the height of each item as needed
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                              color: _selectedProgress == number.toString()
                                  ? Colors.blue
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$number',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              const Text(
                'Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10, // Adjust the number of items as needed
                      itemBuilder: (context, index) {
                        int number =
                            index + 1; // Assuming you want to start from 1
                        return GestureDetector(
                          onTap: () {
                            selectScore(number);
                          },
                          child: Container(
                            width:
                                50, // Adjust the width of each item as needed
                            height:
                                50, // Adjust the height of each item as needed
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                              color: _selectedScore == number.toString()
                                  ? Colors.blue
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$number',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: 290,
                //width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                //padding: const EdgeInsets.all(16.0),
                                textStyle:
                                    const TextStyle(fontSize: buttonFontSize),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: _submit,
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text('Submit'),
                            )),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                //padding: const EdgeInsets.all(16.0),
                                textStyle:
                                    const TextStyle(fontSize: buttonFontSize),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text('Delete'),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(animeSet?.title ?? '...'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submit,
            icon: const Icon(
              Icons.save_outlined,
              size: 35,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
      body: content,
    );
  }
}
