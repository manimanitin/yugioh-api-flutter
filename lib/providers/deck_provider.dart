import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yugioh_api_flutter/models/card.dart';
import 'package:yugioh_api_flutter/services/auth_service.dart';

class DeckProvider extends ChangeNotifier {
  final options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  final String _baseUrl = 'http://loginbackend.somee.com';

  List<CardType> deckCards = [];
  List<CardType> extraDeckCards = [];

  Map<int, int> countDeckCards = {};
  Map<int, int> countExtraDeckCards = {};

  deleteDecks() async {
    deckCards.clear();
    extraDeckCards.clear();
    countDeckCards.clear();
    countExtraDeckCards.clear();
    final dio = Dio(options);
    try {
      final userId = await AuthService().readUserId();
      final token = await AuthService().readToken();
      final response = await dio.delete("$_baseUrl/api/Decks/",
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            "userId": "$userId",
            "deckList": [],
            "extraDeckList": [],
          });
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }

  saveDecks() async {
    final dio = Dio(options);
    List<int> idDeckCards = [];
    List<int> idExtraDeckCards = [];

    for (var element in deckCards) {
      idDeckCards.add(element.id);
    }
    for (var element in extraDeckCards) {
      idExtraDeckCards.add(element.id);
    }
    try {
      final userId = await AuthService().readUserId();
      final token = await AuthService().readToken();
      final response = await dio.post("$_baseUrl/api/Decks/",
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            "userId": "$userId",
            "deckList": idDeckCards,
            "extraDeckList": idExtraDeckCards,
          });
      if ((response.statusCode! ~/ 100) == 2) {
        return "Deck successfully saved";
      } else {
        return "Error saving deck";
      }
    } on Exception catch (e) {
      print(e);
    }

    notifyListeners();
  }

  clearDecks() {
    deckCards.clear();
    extraDeckCards.clear();
    countDeckCards.clear();
    countExtraDeckCards.clear();
    notifyListeners();
  }

  getDecks() async {
    final dio = Dio(options);
    try {
      final userId = await AuthService().readUserId();
      final token = await AuthService().readToken();
      final response = await dio.get(
        "$_baseUrl/api/Decks/$userId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      populateDecks(
          response.data[0]["deckList"], response.data[0]["extraDeckList"]);
    } on Exception catch (e) {
      print(e);
    }
    print(countDeckCards.values);
    print(deckCards.length);
  }

  populateDecks(decklist, extraDeckList) async {
    final dio = Dio(options);
    List<CardType> deck = [];
    List<CardType> extraDeck = [];

    for (var element in decklist) {
      try {
        final response = await dio
            .get("https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$element");
        if (response.data["data"][0]["atk"] != null) {
          final monsterCard =
              CardType.monsterFromJson(response.data["data"][0]);
          deck.add(monsterCard);
        } else {
          final monsterCard =
              CardType.spellTrapFromJson(response.data["data"][0]);
          deck.add(monsterCard);
        }
      } on Exception catch (e) {
        print(e);
      }
    }
    for (var element in extraDeckList) {
      try {
        final response = await dio
            .get("https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$element");
        if (response.data["data"][0]["atk"] != null) {
          final monsterCard =
              CardType.monsterFromJson(response.data["data"][0]);
          extraDeck.add(monsterCard);
        } else {
          final monsterCard =
              CardType.spellTrapFromJson(response.data["data"][0]);
          extraDeck.add(monsterCard);
        }
      } on Exception catch (e) {
        print(e);
      }
    }
    for (var element in deck) {
      print(element.id);
      addToDeck(element);
      notifyListeners();
    }
    for (var element in extraDeck) {
      print(element.id);
      addToDeck(element);
      notifyListeners();
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
      if (countExtraDeckCards.containsKey(card.id)) {
        countExtraDeckCards.remove(card.id);
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
      if (countDeckCards.containsKey(card.id)) {
        countDeckCards.remove(card.id);
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
      if (countExtraDeckCards.containsKey(card.id)) {
        if (countExtraDeckCards[card.id]! > 1) {
          countExtraDeckCards[card.id] = countExtraDeckCards[card.id]! - 1;
          extraDeckCards.remove(card);
          print("ok");
          message = "Deleted 1 ${card.name} from Extra Deck";
        } else {
          countExtraDeckCards.remove(card.id);
          extraDeckCards.remove(card);
          message = "Deleted ${card.name} from Extra Deck";
        }
      } else {
        message = "There is no ${card.name} in the Extra Deck";
      }
    }
    notifyListeners();

    return message;
  }

  _tryDeletingFromDeck(CardType card) {
    String message = "";
    if (deckCards.length == 0) {
      message = "There is no cards in the Deck";
    } else {
      if (countDeckCards.containsKey(card.id)) {
        if (countDeckCards[card.id]! > 1) {
          countDeckCards[card.id] = countDeckCards[card.id]! - 1;
          deckCards.remove(card);
          print("ok");
          message = "Deleted 1 ${card.name} from Deck";
        } else {
          deckCards.remove(card);
          countDeckCards.remove(card.id);

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
      if (extraDeckCards.isEmpty) {
        message = "Added to Extra Deck";
        countExtraDeckCards[card.id] = 1;
        extraDeckCards.add(card);
      } else {
        if (countExtraDeckCards.containsKey(card.id)) {
          if (countExtraDeckCards[card.id]! < 3) {
            countExtraDeckCards[card.id] = countExtraDeckCards[card.id]! + 1;
            extraDeckCards.add(card);
            message = "Added to Extra Deck";
          } else {
            message =
                "There is already 3 copies of this card in the Extra Deck";
          }
        } else {
          countExtraDeckCards[card.id] = 1;
          extraDeckCards.add(card);
          message = "Added to Extra Deck";
        }
      }
    }
    print(message);
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
        countDeckCards[card.id] = 1;
        deckCards.add(card);
      } else {
        if (countDeckCards.containsKey(card.id)) {
          if (countDeckCards[card.id]! < 3) {
            countDeckCards[card.id] = countDeckCards[card.id]! + 1;
            deckCards.add(card);
            message = "Added to Deck";
          } else {
            message = "There is already 3 copies of this card in the Deck";
          }
        } else {
          countDeckCards[card.id] = 1;
          deckCards.add(card);
          message = "Added to Deck";
        }
      }
    }
    print(message);

    notifyListeners();

    return message;
  }
}
