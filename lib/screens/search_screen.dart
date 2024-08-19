import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:yugioh_api_flutter/colors/colors.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
import 'package:yugioh_api_flutter/widgets/card_image.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController controller = ScrollController();
  TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  StreamController<String> streamController = StreamController();
  @override
  void initState() {
    super.initState();
    streamController.stream.debounce(const Duration(seconds: 2)).listen((s) {
      if (s.length > 4) {
        setState(() {
          Provider.of<CardProvider>(context, listen: false).addSearchList(s);
        });
      } else {
        Provider.of<CardProvider>(context, listen: false).emptySearchList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CardType> cardo = Provider.of<CardProvider>(context).getSearchList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search a card',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Enter your search query',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    cardo.clear();
                    _searchQuery = value;
                    streamController.add(value);
                  });
                }),
            const SizedBox(height: 16.0),
            _searchQuery.isEmpty
                ? const Text('Enter a search query')
                : cardo.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            controller: controller,
                            itemCount: cardo.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CardImageContainer(card: cardo[index]),
                                title: Text(cardo[index].name),
                                onTap: () {
                                  Navigator.pushNamed(context, '/details',
                                      arguments: cardo[index]);
                                },
                              );
                            }),
                      )
                    : const CircularProgressIndicator()
            // Add your search results widget here based on the _searchQuery
          ],
        ),
      ),
    );
  }
}
