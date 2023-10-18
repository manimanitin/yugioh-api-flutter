import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yugioh_api_flutter/models/card.dart';

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
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: CachedNetworkImage(
              placeholder: (context, url) => Image.asset(
                  'assets/BackCard.png'), // Your default image here,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: card.cardImages.first.imageUrl,
              height: 250,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                card.desc,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  _CardStats(value: card.atk ?? 0, icon: MdiIcons.sword),
                  const Spacer(),
                  _CardStats(value: card.def ?? 0, icon: MdiIcons.shield),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

class _CardStats extends StatelessWidget {
  const _CardStats({super.key, required this.value, required this.icon});
  final int value;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
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
