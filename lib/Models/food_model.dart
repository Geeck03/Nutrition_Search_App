import 'dart:convert';

FoodData foodDataFromJson(String str) => FoodData.fromJson(json.decode(str));
String foodDataToJson(FoodData data) => json.encode(data.toJson());

class FoodData {
  final FoodSearchCriteria? foodSearchCriteria;
  final int totalHits;
  final int currentPage;
  final int totalPages;
  final List<Food> foods;

  FoodData({
    this.foodSearchCriteria,
    required this.totalHits,
    required this.currentPage,
    required this.totalPages,
    required this.foods,
  });

  factory FoodData.fromJson(Map<String, dynamic> json) => FoodData(
    foodSearchCriteria:
        json["foodSearchCriteria"] != null
            ? FoodSearchCriteria.fromJson(json["foodSearchCriteria"])
            : null,
    totalHits: json["totalHits"] ?? 0,
    currentPage: json["currentPage"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
    foods:
        (json["foods"] as List?)?.map((x) => Food.fromJson(x)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "foodSearchCriteria": foodSearchCriteria?.toJson(),
    "totalHits": totalHits,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "foods": foods.map((x) => x.toJson()).toList(),
  };
}

class FoodSearchCriteria {
  final String? query;
  final List<String> dataType;
  final int? pageSize;
  final int? pageNumber;
  final String? sortBy;
  final String? sortOrder;
  final String? brandOwner;
  final List<String> tradeChannel;
  final DateTime? startDate;
  final DateTime? endDate;

  FoodSearchCriteria({
    this.query,
    required this.dataType,
    this.pageSize,
    this.pageNumber,
    this.sortBy,
    this.sortOrder,
    this.brandOwner,
    required this.tradeChannel,
    this.startDate,
    this.endDate,
  });

  factory FoodSearchCriteria.fromJson(Map<String, dynamic> json) =>
      FoodSearchCriteria(
        query: json["query"],
        dataType: List<String>.from(json["dataType"] ?? []),
        pageSize: json["pageSize"],
        pageNumber: json["pageNumber"],
        sortBy: json["sortBy"],
        sortOrder: json["sortOrder"],
        brandOwner: json["brandOwner"],
        tradeChannel: List<String>.from(json["tradeChannel"] ?? []),
        startDate:
            json["startDate"] != null
                ? DateTime.tryParse(json["startDate"])
                : null,
        endDate:
            json["endDate"] != null ? DateTime.tryParse(json["endDate"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "query": query,
    "dataType": dataType,
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "sortBy": sortBy,
    "sortOrder": sortOrder,
    "brandOwner": brandOwner,
    "tradeChannel": tradeChannel,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
  };
}

class Food {
  final String fdcId;
  final String? dataType;
  final String? description;
  final String? foodCode;
  final List<FoodNutrient> foodNutrients;
  final String? publicationDate;
  final String? scientificName;
  final String? brandOwner;
  final String? gtinUpc;
  final String? ingredients;
  final int? ndbNumber;
  final String? additionalDescriptions;
  final String? allHighlightFields;
  final double? score;

  Food({
    required this.fdcId,
    this.dataType,
    this.description,
    this.foodCode,
    required this.foodNutrients,
    this.publicationDate,
    this.scientificName,
    this.brandOwner,
    this.gtinUpc,
    this.ingredients,
    this.ndbNumber,
    this.additionalDescriptions,
    this.allHighlightFields,
    this.score,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    fdcId: json["fdcId"],
    dataType: json["dataType"],
    description: json["description"],
    foodCode: json["foodCode"],
    foodNutrients:
        (json["foodNutrients"] as List?)
            ?.map((x) => FoodNutrient.fromJson(x))
            .toList() ??
        [],
    publicationDate: json["publicationDate"],
    scientificName: json["scientificName"],
    brandOwner: json["brandOwner"],
    gtinUpc: json["gtinUpc"],
    ingredients: json["ingredients"],
    ndbNumber: json["ndbNumber"],
    additionalDescriptions: json["additionalDescriptions"],
    allHighlightFields: json["allHighlightFields"],
    score: json["score"] != null ? (json["score"] as num).toDouble() : null,
  );

  Map<String, dynamic> toJson() => {
    "fdcId": fdcId,
    "dataType": dataType,
    "description": description,
    "foodCode": foodCode,
    "foodNutrients": foodNutrients.map((x) => x.toJson()).toList(),
    "publicationDate": publicationDate,
    "scientificName": scientificName,
    "brandOwner": brandOwner,
    "gtinUpc": gtinUpc,
    "ingredients": ingredients,
    "ndbNumber": ndbNumber,
    "additionalDescriptions": additionalDescriptions,
    "allHighlightFields": allHighlightFields,
    "score": score,
  };
}

class FoodNutrient {
  final double? number;
  final String? name;
  final double? amount;
  final String? unitName;
  final String? derivationCode;
  final String? derivationDescription;

  FoodNutrient({
    this.number,
    this.name,
    this.amount,
    this.unitName,
    this.derivationCode,
    this.derivationDescription,
  });

  factory FoodNutrient.fromJson(Map<String, dynamic> json) => FoodNutrient(
    number: json["number"] != null ? (json["number"] as num).toDouble() : null,
    name: json["name"] as String?,
    amount:
        (json["amount"] != null) ? (json["amount"] as num).toDouble() : null,
    unitName: json["unitName"] as String?,
    derivationCode: json["derivationCode"] as String?,
    derivationDescription: json["derivationDescription"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "name": name,
    "amount": amount,
    "unitName": unitName,
    "derivationCode": derivationCode,
    "derivationDescription": derivationDescription,
  };
}
