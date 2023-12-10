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
  List<CardType> extraDeckCards = [];

  Map<CardType, int> countDeckCards = {};
  Map<CardType, int> countExtraDeckCards = {};

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

  String addToDeck(CardType card) {
    if (card.extraDeck) {
      return _tryAddingToExtraDeck(card);
    } else {
      return _tryAddingToDeck(card);
    }
  }

  String deleteFromDeck(CardType card) {
    if (card.extraDeck) {
      return _tryDeletingFromExtraDeck(card);
    } else {
      return _tryDeletingFromDeck(card);
    }
  }

  String resetFromDeck(CardType card) {
    if (card.extraDeck) {
      return _tryResetingFromExtraDeck(card);
    } else {
      return _tryResetingFromDeck(card);
    }
  }

  _tryResetingFromExtraDeck(CardType card) {
    String message = "";
    if (extraDeckCards.length == 0) {
      message = "There is no cards in the Extra Deck";
    } else {
      if (countExtraDeckCards.containsKey(card)) {
        countExtraDeckCards.remove(card);
        extraDeckCards.removeWhere((item) => item.name == card.name);
        message = "Deleted ${card.name} from Extra Deck";
      } else {
        message = "There is no ${card.name} in the Extra Deck";
      }
    }
    notifyListeners();

    return message;
  }

  _tryResetingFromDeck(CardType card) {
    String message = "";
    if (deckCards.length == 0) {
      message = "There is no cards in the Deck";
    } else {
      if (countDeckCards.containsKey(card)) {
        countDeckCards.remove(card);
        deckCards.removeWhere((item) => item.name == card.name);
        message = "Deleted ${card.name} from Extra Deck";
      } else {
        message = "There is no ${card.name} in the Extra Deck";
      }
    }
    notifyListeners();

    return message;
  }

  _tryDeletingFromExtraDeck(CardType card) {
    String message = "";
    if (extraDeckCards.length == 0) {
      message = "There is no cards in the Extra Deck";
    } else {
      if (countExtraDeckCards.containsKey(card)) {
        if (countExtraDeckCards[card]! > 1) {
          countExtraDeckCards[card] = countExtraDeckCards[card]! - 1;
          extraDeckCards.remove(card);
          print("ok");
          message = "Deleted 1 ${card.name} from Extra Deck";
        } else {
          countExtraDeckCards.remove(card);
          extraDeckCards.remove(card);
          message = "Deleted ${card.name} from Extra Deck";
        }
      } else {
        message = "There is no ${card.name} in the Extra Deck";
      }
    }
    return message;
  }

  _tryDeletingFromDeck(CardType card) {
    String message = "";
    if (deckCards.length == 0) {
      message = "There is no cards in the Deck";
    } else {
      if (countDeckCards.containsKey(card)) {
        if (countDeckCards[card]! > 1) {
          countDeckCards[card] = countDeckCards[card]! - 1;
          deckCards.remove(card);
          print("ok");
          message = "Deleted 1 ${card.name} from Deck";
        } else {
          deckCards.remove(card);
          countDeckCards.remove(card);

          message = "Deleted ${card.name} from Deck";
        }
      } else {
        message = "There is no ${card.name} in the Extra Deck";
      }
    }
    notifyListeners();

    return message;
  }

  _tryAddingToExtraDeck(CardType card) {
    String message = "";
    if (extraDeckCards.length == 15) {
      message = "Can't add more than 15 cards to the Extra Deck";
    } else {
      print("ok");

      if (extraDeckCards.isEmpty) {
        message = "Added to Extra Deck";
        countExtraDeckCards[card] = 1;
        extraDeckCards.add(card);
      } else {
        if (countExtraDeckCards.containsKey(card)) {
          if (countExtraDeckCards[card]! < 3) {
            countExtraDeckCards[card] = countExtraDeckCards[card]! + 1;
            extraDeckCards.add(card);
            print("ok");
            message = "Added to Extra Deck";
          } else {
            print("ño");

            message =
                "There is already 3 copies of this card in the Extra Deck";
          }
        } else {
          print("ok");
          countExtraDeckCards[card] = 1;
          extraDeckCards.add(card);
          message = "Added to Extra Deck";
        }
      }
    }
    notifyListeners();
    return message;
  }

  String _tryAddingToDeck(CardType card) {
    String message = "";
    if (deckCards.length == 60) {
      message = "Can't add more than 60 cards to the Deck";
    } else {
      if (deckCards.isEmpty) {
        message = "Added to Deck";
        countDeckCards[card] = 1;
        deckCards.add(card);
      } else {
        if (countDeckCards.containsKey(card)) {
          if (countDeckCards[card]! < 3) {
            countDeckCards[card] = countDeckCards[card]! + 1;
            deckCards.add(card);
            message = "Added to Deck";
          } else {
            message = "There is already 3 copies of this card in the Deck";
          }
        } else {
          countDeckCards[card] = 1;
          deckCards.add(card);
          message = "Added to Deck";
        }
      }
    }
    notifyListeners();

    return message;
  }
}
