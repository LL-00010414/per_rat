import 'package:flutter/material.dart';
import 'package:per_rat/models/anime.dart';

class EditScoreScreen extends StatelessWidget {
  const EditScoreScreen({
    super.key,
    required this.anime,
  });

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    const double buttonFontSize = 14;
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
                anime.title,
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
                      anime.status.title,
                      style: TextStyle(
                        color: (anime.status.title.contains('Upcoming')
                            ? Colors.blue
                            : anime.status.title.contains('Ongoing')
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
                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {},
                    child: const Text('Completed'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {},
                    child: const Text('Watching'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        //padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: buttonFontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () {},
                    child: const Text('Plan to Watch'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      right: 12,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          //padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: buttonFontSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {},
                      child: const Text('  On Hold   '),
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
                          //padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: buttonFontSize),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {},
                      child: const Text(' Dropped '),
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
                      scrollDirection: Axis.horizontal,
                      itemCount: (anime.totalEpisodes > 0)
                          ? anime.totalEpisodes + 1
                          : anime.totalEpisodes + 2,
                      itemBuilder: (context, index) {
                        int number = index;
                        // if (anime.totalEpisodes == 0) {
                        //   return Container(
                        //     width:
                        //         50, // Adjust the width of each item as needed
                        //     height:
                        //         50, // Adjust the height of each item as needed
                        //     margin: const EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.blue),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: const Center(
                        //       child: Text(
                        //         '0',
                        //         style: TextStyle(
                        //           fontSize: 18,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width:
                                50, // Adjust the width of each item as needed
                            height:
                                50, // Adjust the height of each item as needed
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
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
                          onTap: () {},
                          child: Container(
                            width:
                                50, // Adjust the width of each item as needed
                            height:
                                50, // Adjust the height of each item as needed
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
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
                height: 295,
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
                            onPressed: () {},
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
        title: Text(anime.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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
