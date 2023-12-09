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
  List<CardType> deckCards = [];

  CardProvider() {
    getRandomCard();
    addRandomCardList();
  }
  getRandomCard() async {
    final dio = Dio(options);
    try {
      final response =
          await dio.get("https://db.ygoprodeck.com/api/v7/randomcard.php");
      print(response.data);
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
      print(e);
    }
  }

  addRandomCardList() async {
    final dio = Dio(options);

    for (var i = 0; i < 5; i++) {
      try {
        final response =
            await dio.get("https://db.ygoprodeck.com/api/v7/randomcard.php");
        print(response.data);
        if (response.data["atk"] != null) {
          final monsterCard = CardType.monsterFromJson(response.data);
          randomCardList.add(monsterCard);
        } else {
          final monsterCard = CardType.spellTrapFromJson(response.data);
          randomCardList.add(monsterCard);
        }
        notifyListeners();

        print("Lista: \n" + randomCardList.length.toString());
      } on Exception catch (e) {
        print(e);
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
    print("se elimino");
  }

  addSearchList(String? fname) async {
    final dio = Dio(options);
    emptySearchList();
    print(searchCardList.length);
    try {
      final response = await dio
          .get("https://db.ygoprodeck.com/api/v7/cardinfo.php?&fname=$fname");
      for (var element in response.data["data"]) {
        if (element["atk"] != null) {
          final monsterCard = CardType.monsterFromJson(element);
          searchCardList.add(monsterCard);
          print(monsterCard.name);
        } else {
          final monsterCard = CardType.spellTrapFromJson(element);
          searchCardList.add(monsterCard);
          print(monsterCard.name);
        }

        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
