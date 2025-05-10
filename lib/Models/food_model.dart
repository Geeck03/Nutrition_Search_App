// To parse this JSON data, do
// Deserialization: Converts a JSON string into a Dart object
// final foodData = foodDataFromJson(jsonString);

// Note about request format: The request formoat provided by the USDA API's
// webiste is incosistent with the actual API response.
// Some of the variables from the API response are not in the correct format.
// This model class is designed to handle the API response and ensure
// that the values are in the correct format.
// Used QuickType to generate the model classes https://app.quicktype.io/
// and Gemini to help polish the code to fit with the acutal API response.

// Serialization/Deserialization
// JSON String -> Dart Objects

import 'dart:convert';

FoodData foodDataFromJson(String str) => FoodData.fromJson(json.decode(str));
String foodDataToJson(FoodData data) => json.encode(data.toJson());

class FoodData {
  final List<Food> foods;

  FoodData({required this.foods});

  factory FoodData.fromJson(Map<String, dynamic> json) => FoodData(
    foods:
        (json["foods"] as List?)?.map((x) => Food.fromJson(x)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    "foods": foods.map((x) => x.toJson()).toList(),
  };
}

class Food {
  final int fdcId;
  final String? dataType;
  final String? description;
  final String? foodCode;
  final List<FoodNutrient> foodNutrients;

  Food({
    required this.fdcId,
    this.dataType,
    this.description,
    this.foodCode,
    required this.foodNutrients,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    fdcId: json["fdcId"] is String ? int.parse(json["fdcId"]) : json["fdcId"],
    // Convert fdcId to String
    dataType: json["dataType"]?.toString(),
    description: json["description"]?.toString(),
    foodCode: json["foodCode"]?.toString(),
    foodNutrients:
        (json["foodNutrients"] as List?)
            ?.map((x) => FoodNutrient.fromJson(x))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    "fdcId": fdcId,
    "dataType": dataType,
    "description": description,
    "foodCode": foodCode,
    "foodNutrients": foodNutrients.map((x) => x.toJson()).toList(),
  };
}

class FoodNutrient {
  final int? nutrientId;
  final String? name;
  final String? nutrientNumber;
  final String? unitName;
  final double? amount;
  final int? rank;
  final int? indentLevel;
  final int? foodNutrientId;

  // Optional, if these keys can appear in other contexts from the API
  final String? derivationCode;
  final String? derivationDescription;

  FoodNutrient({
    this.nutrientId,
    this.name,
    this.nutrientNumber,
    this.unitName,
    this.amount,
    this.rank,
    this.indentLevel,
    this.foodNutrientId,
    this.derivationCode,
    this.derivationDescription,
  });

  factory FoodNutrient.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse a value that might be an int or double from various types
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return FoodNutrient(
      nutrientId: parseInt(json["nutrientId"]),
      name: json["nutrientName"] as String?, // Use "nutrientName"
      nutrientNumber:
          json["nutrientNumber"]
              as String?, // Use "nutrientNumber", keep as String
      unitName: json["unitName"] as String?,
      amount: parseDouble(json["value"]), // Use "value" and parse safely
      rank: parseInt(json["rank"]),
      indentLevel: parseInt(json["indentLevel"]),
      foodNutrientId: parseInt(json["foodNutrientId"]),
      derivationCode:
          json["derivationCode"] as String?, // Keep if API might send it
      derivationDescription:
          json["derivationDescription"] as String?, // Keep if API might send it
    );
  }

  Map<String, dynamic> toJson() => {
    "nutrientId": nutrientId,
    "nutrientName": name, // Map back to API key name
    "nutrientNumber": nutrientNumber,
    "unitName": unitName,
    "value": amount, // Map back to API key name
    "rank": rank,
    "indentLevel": indentLevel,
    "foodNutrientId": foodNutrientId,
    "derivationCode": derivationCode,
    "derivationDescription": derivationDescription,
  };
}
