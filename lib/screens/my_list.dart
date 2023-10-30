import 'package:flutter/material.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({
    super.key,
  });

  //final List<Anime> lastAnime;

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'Watching',
            ),
            Tab(
              text: 'Completed',
            ),
            Tab(
              text: 'On Hold',
            ),
            Tab(
              text: 'Dropped',
            ),
            Tab(
              text: 'Plan to Watch',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: Text(
              'All',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          Center(
            child: Text(
              'Watching',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          Center(
            child: Text(
              'Completed',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          Center(
            child: Text(
              'On Hold',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          Center(
            child: Text(
              'Dropped',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          Center(
            child: Text(
              'Plan to Watch',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
