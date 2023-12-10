import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/providers/card_provider.dart';
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
    final deck = Provider.of<CardProvider>(context).countDeckCards;
    final extraDeck = Provider.of<CardProvider>(context).countExtraDeckCards;

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
              controller: controller,
              itemCount: deck.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final card = deck.entries.elementAt(index);
                return ListTile(
                  leading: CardImageContainer(card: card.key),
                  title: Text(card.key.name),
                  subtitle: Text("${card.value} copies"),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: card.key);
                  },
                );
              }),
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
                return ListTile(
                  leading: CardImageContainer(card: card.key),
                  title: Text(card.key.name),
                  subtitle: Text("${card.value} copies"),
                  onTap: () {
                    Navigator.pushNamed(context, '/details',
                        arguments: card.key);
                  },
                );
              }),
        ),
      ],
    );
  }
}
