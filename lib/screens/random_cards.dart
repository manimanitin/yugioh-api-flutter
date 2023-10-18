import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';

class RandomCards extends StatefulWidget {
  const RandomCards({super.key});
  @override
  State<RandomCards> createState() => _RandomCardsState();
}

class _RandomCardsState extends State<RandomCards> {
  ScrollController controller = ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Provider.of<CardProvider>(context, listen: false).addRandomCardList();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        setState(() {
          _addRandomCard();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void _addRandomCard() {
    setState(() {
      Provider.of<CardProvider>(context, listen: false).addRandomCardList();
      isLoading = false;
    });
  }

  Future refresh() async {
    setState(() {
      Provider.of<CardProvider>(context, listen: false).addRandomCardList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CardType> cardo =
        Provider.of<CardProvider>(context).getRandomCardList();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
            controller: controller,
            itemCount: cardo.length + 1,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              if (index < cardo.length) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Image.asset(
                          'assets/BackCard.png'), // Your default image here,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: cardo[index].cardImages.first.imageUrl,
                      height: 250,
                    ),
                  ),
                  title: Text(cardo[index].name),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: cardo[index]);
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
}
