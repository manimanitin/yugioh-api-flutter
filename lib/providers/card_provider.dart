import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/models/card.dart';

class CardProvider extends ChangeNotifier {
  final options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  CardType randomCard = CardType(
      id: 0,
      name: '',
      type: '',
      frameType: '',
      desc: '',
      cardImages: List.empty(),
      cardPrices: List.empty(),
      cardSets: List.empty(),
      banListStatus: List.empty());

  List<CardType> randomCardList = [];
  List<CardType> searchCardList = [];

  CardProvider() {
    getRandomCard();
    addRandomCardList();
  }
  getRandomCard() async {
    final dio = Dio(options);
    try {
      final response =
          await dio.get("https://db.ygoprodeck.com/api/v7/randomcard.php");
      if (response.data["atk"] != null) {
        final monsterCard = CardType.monsterFromJson(response.data);
        randomCard = monsterCard;
        notifyListeners();
      } else {
        final monsterCard = CardType.spellTrapFromJson(response.data);
        randomCard = monsterCard;
        notifyListeners();
      }
    } on Exception catch (e) {
      (e);
    }
  }

  addRandomCardList() async {
    final dio = Dio(options);

    for (var i = 0; i < 5; i++) {
      try {
        final response =
            await dio.get("https://db.ygoprodeck.com/api/v7/randomcard.php");
        print(response.data['data'][0]);
        if (response.data['data'][0]["atk"] != null) {
          final monsterCard =
              CardType.monsterFromJson(response.data['data'][0]);
          randomCardList.add(monsterCard);
        } else {
          final monsterCard =
              CardType.spellTrapFromJson(response.data['data'][0]);
          randomCardList.add(monsterCard);
        }
        notifyListeners();
      } on Exception catch (e) {
        (e);
      }
    }
  }

  List<CardType> getRandomCardList() {
    return randomCardList;
  }

  List<CardType> getSearchList() {
    return searchCardList;
  }

  emptySearchList() {
    searchCardList.clear();
    notifyListeners();
    ("se elimino");
  }

  addSearchList(String? fname) async {
    final dio = Dio(options);
    emptySearchList();
    (searchCardList.length);
    try {
      final response = await dio
          .get("https://db.ygoprodeck.com/api/v7/cardinfo.php?&fname=$fname");
      for (var element in response.data["data"]) {
        if (element["atk"] != null) {
          final monsterCard = CardType.monsterFromJson(element);
          searchCardList.add(monsterCard);
          (monsterCard.name);
        } else {
          final monsterCard = CardType.spellTrapFromJson(element);
          searchCardList.add(monsterCard);
          (monsterCard.name);
        }

        notifyListeners();
      }
    } on Exception catch (e) {
      (e);
    }
  }
}
