import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/widgets/card_image.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final CardType card =
        ModalRoute.of(context)?.settings.arguments as CardType;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Details"),
      ),
      body: CardScrollView(
        card: card,
      ),
    );
  }
}

class CardScrollView extends StatelessWidget {
  const CardScrollView({super.key, required this.card});
  final CardType card;

  @override
  Widget build(BuildContext context) {
    if (card.desc != '') {
      return CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate.fixed([
            _ImageAndName(card: card),
          ]))
        ],
      );
    } else {
      var children = const <Widget>[
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Cargando...'),
        ),
      ];
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      );
    }
  }
}

class _ImageAndName extends StatelessWidget {
  _ImageAndName({super.key, required this.card});
  final CardType card;

  @override
  Widget build(BuildContext context) {
    print(card.toJson());
    return Column(
      children: [
        Row(
          children: [
            CardImageContainer(card: card),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      card.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      card.type,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardStats(value: card.atk ?? -1, icon: MdiIcons.sword),
                      const SizedBox(
                        width: 30,
                      ),
                      _CardStats(value: card.def ?? -1, icon: MdiIcons.shield),
                    ],
                  ),
                  Row(
                    children: [
                      _CardStats(
                          value: card.linkval ?? -1,
                          icon: MdiIcons.cardsDiamond)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          card.desc,
          style: const TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CardStats extends StatelessWidget {
  const _CardStats({super.key, required this.value, required this.icon});
  final int value;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    if (value < 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blueAccent,
        ),
        const SizedBox(
          width: 1,
        ),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
