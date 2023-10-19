import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
import 'package:yugioh_api_flutter/widgets/widgets.dart';

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
                  leading: CardImageContainer(card: cardo[index]),
                  title: Text(cardo[index].name),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: cardo[index]);
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
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
