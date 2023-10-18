import 'dart:convert';

class CardType {
  int id;
  String name;
  String type;
  String? frameType;
  String desc;
  int? atk;
  int? def;
  int? level;
  String? race;
  String? attribute;
  int? scale;
  String? archetype;
  int? linkval;
  List<String>? linkmarkers;
  List<CardSet> cardSets;
  List<CardImage> cardImages;
  List<CardPrice> cardPrices;
  List<CardBan> banListStatus;

  CardType.monster({
    required this.id,
    required this.name,
    required this.type,
    required this.frameType,
    required this.desc,
    required this.atk,
    required this.def,
    required this.level,
    required this.race,
    required this.attribute,
    required this.cardSets,
    required this.cardImages,
    required this.cardPrices,
    required this.banListStatus,
    required this.archetype,
  });

  CardType.spelltraps({
    required this.id,
    required this.name,
    required this.type,
    required this.desc,
    required this.race,
    required this.cardImages,
    required this.cardPrices,
    required this.cardSets,
    required this.banListStatus,
  });

  CardType({
    required this.id,
    required this.name,
    required this.type,
    required this.frameType,
    required this.desc,
    required this.cardImages,
    required this.cardPrices,
    required this.cardSets,
    required this.banListStatus,
  });

  factory CardType.monsterFromRawJson(String str) =>
      CardType.monsterFromJson(json.decode(str));

  factory CardType.spellTrapFromRawJson(String str) =>
      CardType.spellTrapFromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardType.spellTrapFromJson(Map<String, dynamic> json) =>
      CardType.spelltraps(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        desc: json["desc"],
        race: json["race"],
        cardSets: json["card_sets"] != null
            ? List<CardSet>.from(
                json["card_sets"].map((x) => CardSet.fromJson(x)))
            : List.empty(),
        cardImages: List<CardImage>.from(
            json["card_images"].map((x) => CardImage.fromJson(x))),
        cardPrices: List<CardPrice>.from(
            json["card_prices"].map((x) => CardPrice.fromJson(x))),
        banListStatus: json["ban_list"] != null
            ? List<CardBan>.from(
                json["ban_list"].map((x) => CardBan.fromJson(x)))
            : List.empty(),
      );

  factory CardType.monsterFromJson(Map<String, dynamic> json) =>
      CardType.monster(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        frameType: json["frameType"] ?? '',
        desc: json["desc"],
        atk: json["atk"],
        def: json["def"],
        level: json["level"],
        race: json["race"],
        attribute: json["attribute"],
        archetype: json["archetype"],
        cardSets: json["card_sets"] != null
            ? List<CardSet>.from(
                json["card_sets"].map((x) => CardSet.fromJson(x)))
            : List.empty(),
        cardImages: List<CardImage>.from(
            json["card_images"].map((x) => CardImage.fromJson(x))),
        cardPrices: List<CardPrice>.from(
            json["card_prices"].map((x) => CardPrice.fromJson(x))),
        banListStatus: json["ban_list"] != null
            ? List<CardBan>.from(
                json["ban_list"].map((x) => CardBan.fromJson(x)))
            : List.empty(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "frameType": frameType,
        "desc": desc,
        "atk": atk,
        "def": def,
        "level": level,
        "race": race,
        "attribute": attribute,
        "scale": scale,
        "linkval": linkval,
        "archetype": archetype,
        "linkmarkers": linkmarkers != null
            ? List<dynamic>.from(linkmarkers!.map((x) => x.toString()))
            : List.empty(),
        "card_sets": List<dynamic>.from(cardSets.map((x) => x.toJson())),
        "card_images": List<dynamic>.from(cardImages.map((x) => x.toJson())),
        "card_prices": List<dynamic>.from(cardPrices.map((x) => x.toJson())),
        "banlist": List<dynamic>.from(banListStatus.map((x) => x.toString())),
      };
}

class CardImage {
  int id;
  String imageUrl;
  String imageUrlSmall;
  String imageUrlCropped;

  CardImage({
    required this.id,
    required this.imageUrl,
    required this.imageUrlSmall,
    required this.imageUrlCropped,
  });

  factory CardImage.fromRawJson(String str) =>
      CardImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardImage.fromJson(Map<String, dynamic> json) => CardImage(
        id: json["id"] ?? 0,
        imageUrl: json["image_url"],
        imageUrlSmall: json["image_url_small"],
        imageUrlCropped: json["image_url_cropped"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "image_url_small": imageUrlSmall,
        "image_url_cropped": imageUrlCropped,
      };
}

class CardPrice {
  String cardmarketPrice;
  String tcgplayerPrice;
  String ebayPrice;
  String amazonPrice;
  String coolstuffincPrice;

  CardPrice({
    required this.cardmarketPrice,
    required this.tcgplayerPrice,
    required this.ebayPrice,
    required this.amazonPrice,
    required this.coolstuffincPrice,
  });

  factory CardPrice.fromRawJson(String str) =>
      CardPrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardPrice.fromJson(Map<String, dynamic> json) => CardPrice(
        cardmarketPrice: json["cardmarket_price"],
        tcgplayerPrice: json["tcgplayer_price"],
        ebayPrice: json["ebay_price"],
        amazonPrice: json["amazon_price"],
        coolstuffincPrice: json["coolstuffinc_price"] ?? 'unknown',
      );

  Map<String, dynamic> toJson() => {
        "cardmarket_price": cardmarketPrice,
        "tcgplayer_price": tcgplayerPrice,
        "ebay_price": ebayPrice,
        "amazon_price": amazonPrice,
        "coolstuffinc_price": coolstuffincPrice,
      };
}

class CardSet {
  String setName;
  String setCode;
  String setRarity;
  String setRarityCode;
  String setPrice;

  CardSet({
    required this.setName,
    required this.setCode,
    required this.setRarity,
    required this.setRarityCode,
    required this.setPrice,
  });

  factory CardSet.fromRawJson(String str) => CardSet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardSet.fromJson(Map<String, dynamic> json) => CardSet(
        setName: json["set_name"],
        setCode: json["set_code"],
        setRarity: json["set_rarity"],
        setRarityCode: json["set_rarity_code"] ?? '',
        setPrice: json["set_price"],
      );

  Map<String, dynamic> toJson() => {
        "set_name": setName,
        "set_code": setCode,
        "set_rarity": setRarity,
        "set_rarity_code": setRarityCode,
        "set_price": setPrice,
      };
}

class CardBan {
  String banTcg;
  String banOcg;
  String banGoat;

  CardBan({required this.banTcg, required this.banOcg, required this.banGoat});

  factory CardBan.fromRawJson(String str) => CardBan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardBan.fromJson(Map<String, dynamic> json) => CardBan(
        banTcg: json["ban_tcg"] ?? 'unlimited',
        banOcg: json["ban_ocg"] ?? 'unlimited',
        banGoat: json["ban_goat"] ?? 'unlimited',
      );

  Map<String, dynamic> toJson() => {
        "ban_tcg": banTcg,
        "ban_ocg": banOcg,
        "ban_goat": banGoat,
      };
}
