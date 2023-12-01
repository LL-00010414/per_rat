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
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 15,
                ),
                child: Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
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
            ),
          )
        ],
      ),
      body: content,
    );
  }
}
