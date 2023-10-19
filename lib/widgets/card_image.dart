import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/models/card.dart';

class CardImageContainer extends StatelessWidget {
  const CardImageContainer({super.key, required this.card});
  final CardType card;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: CachedNetworkImage(
        placeholder: (context, url) =>
            Image.asset('assets/BackCard.png'), // Your default image here,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        imageUrl: card.cardImages.first.imageUrl,
        height: 250,
      ),
    );
  }
}
