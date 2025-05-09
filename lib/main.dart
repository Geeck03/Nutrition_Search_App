import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:honors_app/models/food_model.dart';

// U.S. Department of Agriculture, Agricultural Research Service. FoodData Central, 2019. fdc.nal.usda.gov.

//root of app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NetworkManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = true; // Variable to track dark mode

  //Toggles dark mode on and off
  // This function is called when the user taps the button.
  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode; // Toggle the dark mode variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), // Use dark theme when isDarkMode is true
      themeMode:
          isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light, // Set the theme mode based on isDarkMode
      home: HomeScreen(
        toggleTheme: toggleDarkMode,
      ), // Pass the toggleTheme function to the home screen
    );
  }
}

//Use to mange the search query and the API call to the USDA API
// This class is responsible for fetching food data from the USDA API
// and managing the state of the app.
class NetworkManager extends ChangeNotifier {
  final String _baseURL = 'https://api.nal.usda.gov/fdc/v1';
  final String _apiKey = 'ikjpw5Ld99JHwUWTFjCEqRctWl8kGeldAVhuC0Oa';
  FoodData? foodData;
  // …
  //List<Food> get foodsList => foodData?.foods ?? [];
  //NetworkManager({required this.baseUrl, required this.BearerToken});
  //!5 changed from false
  bool isLoading = false; // Flag to indicate loading state
  String? errorMessage; // Error message to display in case of failure
  //!3
  //FoodData? foodData; // FoodData object to hold the fetched data
  String searchQuery = '';

  Future<void> searchFoods(String query) async {
    if (query.isEmpty) return;

    isLoading = true; //when function is called, set loading to true
    errorMessage = null;
    notifyListeners();

    //Creates the URL for the API call

    // curl https://api.nal.usda.gov/fdc/v1/foods/search?api_key=DEMO_KEY&query=Cheddar%20Cheese

    final url = Uri.parse(
      '$_baseURL/foods/search?api_key=$_apiKey&query=$query',
    );

    final headers = {
      //'Authorization': 'Bearer $_bearerToken',
      'accept': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      //final response = await http.get('//api.nal.usda.gov/fdc/v1/foods/search?api_key=DEMO_KEY&query=Cheddar%20Cheese');
      if (response.statusCode == 200) {
        //final data = jsonDecode(response.body);
        //!4 changed the results key to foods to match with JSOn
        //print("Got to 200");

        //!5

        errorMessage = 'got to 200';
        foodData = foodDataFromJson(response.body);
        // Deserialize the JSON response
        //final foodData = FoodData.fromJson(data); // Deserialize the JSON response
        // final foodList = (data['foods'] as List).map((e) => FoodData.fromMap);
      } else {
        errorMessage =
            'Failed to fetch foods. Status code ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'An error occured $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class HomeScreen extends StatelessWidget {
  final Function
  toggleTheme; // Function to toggle the them// Food object to display

  const HomeScreen({super.key, required this.toggleTheme}); // Constructor

  @override
  Widget build(BuildContext context) {
    final networkManager = Provider.of<NetworkManager>(
      context,
    ); // 1! add network provider
    //String? food;

    //FoodData foodData;

    // 1! add network provider
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition App 23'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Nutrition APP!"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              onSubmit: (query) async {
                Text("On submit: $query"); // Print the search query
                await networkManager.searchFoods(query); //!2
              }, //
            ),
          ),

          //!3
          if (networkManager.isLoading) const CircularProgressIndicator(),
          if (networkManager.errorMessage != null)
            ErrorView(message: networkManager.errorMessage!),
          if (!networkManager.isLoading &&
              networkManager.foodData != null &&
              networkManager.foodData!.foods.isEmpty)
            const EmptyResultsView(), // Display when no results are found

          if (!networkManager.isLoading &&
              networkManager.foodData != null &&
              networkManager.foodData!.foods.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: networkManager.foodData!.foods.length,
                itemBuilder: (context, index) {
                  //!6 should it be final
                  final foodItem = networkManager.foodData!.foods[index];

                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FoodDetailScreen(food: foodItem),
                          ),
                        ),
                    child: FoodRow(food: foodItem), // Display the food item
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

//UI for serach bar. Sends the search query to the parent widget
// when the search button is pressed.
class SearchBar extends StatelessWidget {
  final Function(String) onSubmit; // on submit state takes it
  const SearchBar({super.key, required this.onSubmit}); // Constructor

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Search for food',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed:
              () => onSubmit(
                controller.text,
              ), // Call the onSubmit function with the text from the TextField
        ),
      ],
    );
  }
}

// UI for displaying the food item in a list.
class FoodRow extends StatelessWidget {
  final Food food; // Food object to display

  const FoodRow({super.key, required this.food}); // Constructor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        'hi',
        //food.fdcId.toString(), // Display the food name
        //food.description ?? "No description available",
      ), // Display the food name
      title: Text('Add a description'), // Display the serving description
      //trailing: Text('${food.suggestedServing.servingSize}${food.suggestedServing.servingUnit}'), // Display the serving size and unit
    );
  }
}

class FoodDetailView extends StatelessWidget {
  final Food foodItem;
  // Food object to display

  const FoodDetailView({super.key, required this.foodItem}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("food description"), // Display the food name in the app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('hi', style: const TextStyle(fontSize: 18))],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 50, color: Colors.red),
          Text(message, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class EmptyResultsView extends StatelessWidget {
  const EmptyResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 50, color: Colors.grey),
          Text('No results found'),
          Text(
            'Try searching for something else',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FoodDetailScreen extends StatelessWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("hi")), // Display the food name in the app bar
    );
  }
}

// To parse this JSON data, do
//

// Deserialization: Converts a JSON string into a Dart object
// final foodData = foodDataFromJson(jsonString);

// Used QuickType to generate the model classes https://app.quicktype.io/
/* 
This code defines how to deserialize JSON into Dart objects 
and serialize Dart objects back into JSON. 
*/

// Serialization/Deserialization
// JSON String -> Dart Objects
