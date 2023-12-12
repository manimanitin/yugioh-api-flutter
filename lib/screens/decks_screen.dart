import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
import 'package:yugioh_api_flutter/providers/deck_provider.dart';
import 'package:yugioh_api_flutter/widgets/card_image.dart';

class DeckScreen extends StatefulWidget {
  const DeckScreen({super.key});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final deck = Provider.of<DeckProvider>(context).countDeckCards;
    final extraDeck = Provider.of<DeckProvider>(context).countExtraDeckCards;
    final deckCount = Provider.of<DeckProvider>(context).deckCards;
    final extraDeckCount = Provider.of<DeckProvider>(context).extraDeckCards;

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Deck',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              controller: ScrollController(),
              itemCount: deck.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final card = deck.entries.elementAt(index);
                final cardlec =
                    deckCount.firstWhere((element) => card.key == element.id);
                return ListTile(
                  leading: CardImageContainer(card: cardlec),
                  title: Text(cardlec.name),
                  subtitle: Text("${card.value} copies"),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: cardlec);
                  },
                );
              }),
        ),
        Text(
          "Total cards in deck: ${deckCount.length}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Extra Deck',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              controller: controller,
              itemCount: extraDeck.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final card = extraDeck.entries.elementAt(index);
                final cardlec = extraDeckCount
                    .firstWhere((element) => card.key == element.id);
                return ListTile(
                  leading: CardImageContainer(card: cardlec),
                  title: Text(cardlec.name),
                  subtitle: Text("${card.value} copies"),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: cardlec);
                  },
                );
              }),
        ),
        Text(
          "Total cards in Extra Deck: ${extraDeckCount.length}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
