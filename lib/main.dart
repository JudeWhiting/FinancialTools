import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Variables {
  final double personalAllowanceThreshold = 12570;
  final double basicRateThreshold = 50270;
  final double basicRateMultiplier = 0.2;
  final double higherRateThreshold = 125140;
  final double higherRateMultiplier = 0.4;
  final double additionalRateMultiplier = 0.45;

  final double niNoPaymentThreshold = 241;
  final double niStandardThreshold = 967;
  final double niStandardMultiplier = 0.08;
  final double niExtraMultiplier = 0.02;
  

}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 41, 255, 34)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}



class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  var income = 0.0;
  void updateIncome(double userInputIncome) {
    income = userInputIncome;
    notifyListeners();
  }
  
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = TakeHomePayPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_alert),
                      label: Text('Take-home Pay'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TakeHomePayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final TextEditingController payController = TextEditingController();



    String formatNumber (double pay) {
      String roundedPay = pay.toStringAsFixed(2);
      int count = 0;
      for (int i = 3; i < roundedPay.length; i++) {
        if (count == 3) {
          roundedPay = '${roundedPay.substring(0, roundedPay.length - i)},${roundedPay.substring(roundedPay.length - i)}';
          count = 0;
        }
        else {
          count += 1;
        }
      }
      String output = '£$roundedPay';

      return output;
    }

    double calculateTaxDeductions (double pay) {
      if (pay > Variables().higherRateThreshold) {
        return Variables().additionalRateMultiplier * (pay - Variables().higherRateThreshold) + calculateTaxDeductions(Variables().higherRateThreshold);
      }
      else if (pay > Variables().basicRateThreshold) {
        return Variables().higherRateMultiplier * (pay - Variables().basicRateThreshold) + calculateTaxDeductions(Variables().basicRateThreshold);
      }
      else if (pay > Variables().personalAllowanceThreshold) {
        return Variables().basicRateMultiplier * (pay - Variables().personalAllowanceThreshold);
      }
      else {
        return 0;
      }
    }

    double calculateNiDeductions(double payWeekly) {
      
      if (payWeekly > Variables().niStandardThreshold) {
        return Variables().niExtraMultiplier * (payWeekly - Variables().niStandardThreshold) + calculateNiDeductions(Variables().niStandardThreshold);
      }
      else if (payWeekly > Variables().niNoPaymentThreshold) {
        return Variables().niStandardMultiplier * (payWeekly - Variables().niNoPaymentThreshold);
      }
      else {
        return 0;
      }
    }
    


    return Column(
      children: <Widget>[
         SizedBox(width: 100, child: TextField(controller: payController,)),
         SizedBox(height: 20),
         ElevatedButton(onPressed: () {appState.updateIncome(double.parse(payController.text));}, child: Text('Go!')),
         SizedBox(height: 20),
         SizedBox(child: Text(appState.income.toString())),
         SizedBox(height: 20),
         Table(
          border: TableBorder.all(color: Colors.black, width: 2),
          columnWidths: {
            0: FixedColumnWidth(100), // Set a fixed width for the first column
            1: FixedColumnWidth(100), // Set a fixed width for the second column
            2: FixedColumnWidth(100),
            3: FixedColumnWidth(100),
          },
          children: [
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Yearly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Monthly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Weekly', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Gross Income', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(appState.income / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Pension', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 2, Column 1'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 2, Column 2'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 2, Column 2'),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Tax', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(calculateTaxDeductions(appState.income))),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(calculateTaxDeductions(appState.income) / 12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(calculateTaxDeductions(appState.income) / 52)),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('National Insurance', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(52 * calculateNiDeductions(appState.income / 52))),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber((52 *calculateNiDeductions(appState.income / 52))/12)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(formatNumber(calculateNiDeductions(appState.income / 52))),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Student Loan', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 1'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 2'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 2'),
                )),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Take Home', style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 1'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 2'),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Row 3, Column 2'),
                )),
              ],
            ),
          ],
         ),
      ]
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}

